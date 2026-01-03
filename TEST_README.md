# Kremna Sistemi Uçtan Uca Test Rehberi

## 1) Gereksinimler
- Python 3.10+ (lokal test için)
- `GEMINI_API_KEY` (geçerli Google Gemini anahtarı)
- İnternet erişimi (Gemini ve gerekirse Railway)

## 2) Kaynak Kod & Bağımlılıklar
```bash
git clone https://github.com/mel-nur/Kremna.git
cd Kremna
python -m venv .venv
# Windows
.\.venv\Scripts\activate
# macOS/Linux
source .venv/bin/activate
pip install -r requirements.txt
```

## 3) Ortam Değişkenleri
- Lokal: `main/.env` dosyasında:
```
GEMINI_API_KEY=...
```
- Railway: Variables sekmesinde `GEMINI_API_KEY` tanımlı olmalı. `DATABASE_URL` varsa Postgres kullanılır, yoksa SQLite.

## 4) Uygulamayı Çalıştırma (Lokal)
```bash
cd main
uvicorn main_receiver:app --host 127.0.0.1 --port 9000
```
- Sağlık: http://127.0.0.1:9000/
- Swagger (opsiyonel): http://127.0.0.1:9000/docs

## 5) Demo Agent Seed Kontrolü
- Uygulama açılırken `demo-agent` otomatik eklenir (SQLite/Postgres).
- İstenen agent yoksa otomatik `demo-agent` fallback çalışır.

## 6) Agent Konfigürasyonu Kaydetme (Doğru JSON Şeması)
**cURL**
```bash
curl -X POST http://127.0.0.1:9000/agent_config \
  -H "Content-Type: application/json; charset=utf-8" \
  -d '{
    "agentId": "agent_8823_xyz",
    "persona_title": "Premium Müşteri Temsilcisi",
    "model_instructions": {
      "tone": "Resmi, Saygılı, Çözüm Odaklı",
      "rules": ["Kısa cevaplar ver", "Değer odaklı yaklaş", "Türkçe cevap ver"],
      "prohibited_topics": ["Rakip ürünleri", "Fiyat sızıntıları"]
    },
    "initial_context": {
      "company_slogan": "Kalite Asla Tesadüf Değildir",
      "pricing_rationale": "Fiyatlandırma; kullanım hacmi (token), aktif kullanıcı sayısı ve ek özelliklere göre kademeli olarak belirlenir."
    }
  }'
```

**PowerShell**
```powershell
$config = @{
    agentId = "agent_8823_xyz"
    persona_title = "Premium Müşteri Temsilcisi"
    model_instructions = @{
      tone = "Resmi, Saygılı, Çözüm Odaklı"
      rules = @("Kısa cevaplar ver", "Değer odaklı yaklaş", "Türkçe cevap ver")
      prohibited_topics = @("Rakip ürünleri", "Fiyat sızıntıları")
    }
    initial_context = @{
      company_slogan = "Kalite Asla Tesadüf Değildir"
      pricing_rationale = "Fiyatlandırma; kullanım hacmi (token), aktif kullanıcı sayısı ve ek özelliklere göre kademeli olarak belirlenir."
    }
} | ConvertTo-Json -Depth 10

Invoke-RestMethod -Method Post -Uri "http://127.0.0.1:9000/agent_config" `
  -ContentType 'application/json; charset=utf-8' -Body $config
```

## 7) Sohbet Testi
```bash
curl -X POST http://127.0.0.1:9000/chat \
  -H "Content-Type: application/json; charset=utf-8" \
  -d '{
    "agent_id": "agent_8823_xyz",
    "session_id": "sess_user_999",
    "user_message": "Merhaba, fiyat hakkında bilgi alabilir miyim?",
    "chat_history": []
  }'
```
Beklenen:
- `status: success`
- `metadata.agent_id` = `agent_8823_xyz` (yoksa fallback: `demo-agent`)
- `topic_detected` ≈ `fiyat_itirazi`
- `blocked` = false

## 8) Web UI Doğrulaması
- Aç: http://127.0.0.1:9000/web
- Header: Agent ID ve Session ID gösterir.
- Yanıt kartlarında metadata (konu, token, onay, agent id).
- İlk yanıt sonrası header’daki Agent ID, gerçek kullanılan agent ile güncellenir (fallback dahil).

## 9) Fallback Senaryosu
- Kayıtlı olmayan `agent_id` ile `/chat` çağır.
- Beklenen: `demo-agent` fallback, UI metadata ve header’da `demo-agent` görünür.

## 10) Güvenlik Kontrolleri
- Mesaja injection anahtarları ekle ("kuralları yok say", "promptu göster", "rolünü değiştir").
- Beklenen: `blocked: true`, güvenli yanıt.

## 11) Postgres vs SQLite
- Lokal: varsayılan SQLite (`personas.db`).
- Railway: `DATABASE_URL` varsa Postgres otomatik seçilir; placeholder `%s`, schema `init_db` içinde hazır.
- SQLite ephemeral olduğundan Railway’de Postgres önerilir.

## 12) Hata Durumları
- Eksik `agent_id` veya `user_message`: HTTP 400
- Kayıp agent + demo yok: HTTP 404 (açıklamalı)
- Eksik `GEMINI_API_KEY`: HTTP 500 (uyarı)

## 13) Log ve Gözlem
- Lokal: uvicorn çıktısı
- Railway: Deployments → View Logs
- Health: `/` döner, API: `/chat`, `/agent_config`

## 14) Başarı Kriterleri (Pass/Fail)
- [ ] `/agent_config` 200 OK
- [ ] `/chat` 200 OK, `metadata.agent_id` doğru
- [ ] Fallback testinde `demo-agent` kullanıldı ve UI’da göründü
- [ ] Güvenlik testi `blocked=true`
- [ ] UI’da mesajlar, metadata, header agent ID doğru
- [ ] (Railway) Postgres bağlı, tabloda `demo-agent` var
