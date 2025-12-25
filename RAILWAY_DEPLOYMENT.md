# 🚂 Railway Deployment Kılavuzu (Production: kremna-production.up.railway.app)

## Hızlı Başlangıç

### 1. Railway Hesabı
- [railway.app](https://railway.app/) → GitHub ile giriş yapın

### 2. Proje Oluştur
```bash
# Railway CLI (opsiyonel)
npm i -g @railway/cli
railway login
railway init
railway up
```

**VEYA Web UI ile:**
1. Dashboard → **New Project**
2. **Deploy from GitHub repo** seçin
3. Bu repo'yu seçin
4. Railway otomatik Dockerfile'ı algılar

### 3. Environment Variables
Railway dashboard → **Variables** → Ekle:

```
GEMINI_API_KEY=your_valid_gemini_api_key_here
```

### 4. Domain
Production domain: **https://kremna-production.up.railway.app**

- Public Networking: Metal Edge, Port 8080 (URL'de port belirtmeye gerek yok)
- Private Networking: `kremna.railway.internal` (servisler arası dahili iletişim)

### 5. Hızlı Test
- Ana sayfa: https://kremna-production.up.railway.app/
- Health check: `GET /` (chatbot.html döner)

---

## 📋 Deployment Checklist

- [x] Python runtime: `python@3.13.11` (Railway)
- [x] Başlatma komutu (Procfile): `web: cd main && uvicorn main_receiver:app --host 0.0.0.0 --port ${PORT:-8080}`
- [x] `PORT` ortam değişkeni Railway tarafından otomatik set edilir
- [x] `GEMINI_API_KEY` Railway Variables altında ekli
- [x] Deployment başarılı (Europe-West4, 1 replica)
- [ ] Test ekibi için agent config POST edildi

---

## 🔧 Railway Environment Variables

| Variable | Açıklama | Zorunlu |
|----------|----------|---------|
| `GEMINI_API_KEY` | Google Gemini API anahtarı | ✅ Evet |
| `PORT` | Railway otomatik set eder | ✅ Otomatik |

---

## 🗄️ Veritabanı (SQLite)

⚠️ **Önemli:** Railway ephemeral filesystem kullanır. Container yeniden başlatılınca SQLite DB sıfırlanır.

**Çözümler:**

### Seçenek 1: Agent Config'i Her Deploy'da Kaydet
Deploy sonrası (ve her yeniden başlatma sonrası) agent konfigürasyonunu kaydetmek için:
```bash
curl -X POST https://kremna-production.up.railway.app/agent_config \
  -H "Content-Type: application/json" \
  -d '{
    "agentId": "agent_8823_xyz",
    "persona_title": "Premium Müşteri Temsilcisi",
    "model_instructions": {
      "tone": "Resmi, Saygılı",
      "rules": ["Kısa cevaplar", "Değer odaklı"],
      "prohibited_topics": ["Rakip fiyatları"]
    },
    "initial_context": {
      "company_slogan": "Kalite Asla Tesadüf Değildir"
    }
  }'
```

### Seçenek 2: Railway Volume (Kalıcı Depolama)
1. Railway Dashboard → **Volumes**
2. **New Volume** → Mount path: `/app/data`
3. `main_receiver.py` → DB_PATH: `/app/data/personas.db`

### Seçenek 3: Railway Postgres (Önerilen - Ücretli)
1. **New** → **Database** → **Postgres**
2. `main_receiver.py`'yi SQLite yerine Postgres kullanacak şekilde düzenle

---

## 🚀 Deploy Sonrası

### Agent Config Kaydı
```powershell
$config = @{
    agentId = "agent_8823_xyz"
    persona_title = "Premium Müşteri Temsilcisi"
    model_instructions = @{
      tone = "Resmi, Saygılı, Çözüm Odaklı"
      rules = @("Kısa cevaplar", "Değer odaklı")
      prohibited_topics = @("Rakip fiyatları")
    }
    initial_context = @{
      company_slogan = "Kalite Asla Tesadüf Değildir"
    }
} | ConvertTo-Json -Depth 10

Invoke-RestMethod -Method Post -Uri "https://kremna-production.up.railway.app/agent_config" `
  -ContentType 'application/json; charset=utf-8' -Body $config
```

### Test
- Ana sayfa: https://kremna-production.up.railway.app/
- Postman/cURL ile hızlı test örnekleri aşağıda

---

## 📊 Logs & Monitoring

Railway Dashboard → **Deployments** → Seçilen deploy → **View Logs**

```
INFO:     Uvicorn running on http://0.0.0.0:8080
INFO:     Started server process
INFO:     Application startup complete.
```

---

## 🔄 Auto-Deploy

Railway GitHub ile entegre. Her push otomatik deploy tetikler.

**Disable etmek için:** Settings → **Auto-Deploy** → OFF

---

## 💡 İpuçları

1. **Free Tier:** 500 saat/ay ($5 değerinde) ücretsiz
2. **Custom Domain:** Settings → Add domain
3. **Scaling:** Railway otomatik ölçeklendirir
4. **Logs:** Real-time log streaming
5. **Metrics:** CPU, RAM, Network kullanımı

---

## 🐛 Sorun Giderme

### Port Hatası
```
Error binding to port
```
✅ `main_receiver.py` PORT env'i kullanıyor (düzeltildi)

### API Key Invalid
```
Gemini API hatası: 400 API key not valid
```
✅ Railway Variables → `GEMINI_API_KEY` kontrol et

### Agent Bulunamadı
```
Agent bulunamadı: agent_8823_xyz
```
✅ Deploy sonrası agent config POST et (yukarıdaki komut)

### SQLite DB Sıfırlanıyor
✅ Railway Volume kullan veya Postgres'e geç

---

## 📞 Destek

- Railway Docs: https://docs.railway.app/
- Railway Discord: https://discord.gg/railway
- API Dokümantasyonu: `API_DOCUMENTATION.md`

---

## 🔬 Test Ekibi için Hızlı Komutlar

Aşağıdaki komutlar production domain üzerinde test içindir.

1) Agent konfigürasyonu kaydet (repo içindeki örnek dosya):
```bash
curl -X POST https://kremna-production.up.railway.app/agent_config \
  -H "Content-Type: application/json" \
  -d @agent_8823_config.json
```

2) Sohbet isteği gönder (örnek):
```bash
curl -X POST https://kremna-production.up.railway.app/chat \
  -H "Content-Type: application/json; charset=utf-8" \
  -d @test_chat_request.json
```

3) Eski formatla persona ekleme (opsiyonel/geriye dönük):
```bash
curl -X POST https://kremna-production.up.railway.app/persona \
  -H "Content-Type: application/json" \
  -d '{"name":"Yardımcı Asistan","tone":"Arkadaş canlısı","constraints":"Kısa cevaplar ver"}'
```

Notlar:
- `GEMINI_API_KEY` Railway Variables altında tanımlı olmalıdır; aksi halde `/chat` çağrıları hata döner.
- `/` endpointi HTML döner; API için `POST /agent_config` ve `POST /chat` kullanılmalıdır.
- Production ortamı: Europe-West4, 1 replica.
