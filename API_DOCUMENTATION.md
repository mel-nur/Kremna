# 🤖 AI Chatbot Sistemi - Proje Dokümantasyonu

## 📋 Proje Özeti

Bu proje, **Google Gemini API** kullanarak özelleştirilebilir AI chatbot'lar oluşturmak için geliştirilmiş bir sistemdir. Dashboard ve Chat Core ekipleri ile entegre çalışacak şekilde tasarlanmıştır.

### 🎯 Ana Özellikler

- ✅ **Dinamik Agent Konfigürasyonu**: Dashboard'dan agent ayarları yönetimi
- ✅ **Akıllı Sohbet Yönetimi**: Chat history ile bağlam farkındalığı
- ✅ **Konu Tespiti**: Otomatik topic detection (fiyat, garanti, ürün bilgisi)
- ✅ **Yasaklı Konu Kontrolü**: Prohibited topics filtreleme
- ✅ **Token Takibi**: Maliyet optimizasyonu için token sayımı
- ✅ **Modern Web Arayüzü**: Test ve demo için hazır UI
- ✅ **Geriye Dönük Uyumluluk**: Eski persona formatı desteği

---

## 🏗️ Sistem Mimarisi

```
┌─────────────────┐         ┌──────────────────┐         ┌─────────────────┐
│   Dashboard     │────────▶│  Port Yönetimi   │────────▶│  Main Sunucu    │
│   (Agent Config)│         │   (Port 8000)    │         │   (Port 9000)   │
└─────────────────┘         │                  │         └─────────────────┘
                            │  /send_json      │                │
┌─────────────────┐         │  (Proxy)         │                │
│   Chat Core     │────────▶│                  │────────────────┘
│   (Mesajlar)    │         └──────────────────┘                │
└─────────────────┘                                             │
                                                                ▼
┌─────────────────┐                                    ┌─────────────────┐
│   Web Arayüzü   │───────────────────────────────────▶│  Gemini API     │
│  (chatbot.html) │         Direkt Bağlantı            │  (AI Engine)    │
└─────────────────┘                                    └─────────────────┘
```

---

## 📁 Proje Yapısı

```
chat-bot/
│
├── 📂 main/                          # Ana Sunucu (Port 9000)
│   ├── main_receiver.py             # FastAPI sunucu, tüm iş mantığı
│   ├── .env                         # Gemini API anahtarı
│   ├── requirements.txt             # Python bağımlılıkları
│   └── __pycache__/                 # Python cache
│
├── 📂 port-yönetimi/                # Proxy Sunucu (Port 8000)
│   └── local_api_server.py          # JSON yönlendirme proxy
│
├── 📂 web-ui/                       # Web Arayüzü
│   ├── chatbot.html                 # Modern chatbot UI
│   └── README.md                    # UI kullanım kılavuzu
│
├── 📂 .venv/                        # Python virtual environment
│
├── 📄 personas.db                   # SQLite veritabanı
├── 📄 list_models.py                # Gemini model listesi
├── 📄 test_new_format.ps1           # Yeni format test scripti
├── 📄 test_system.ps1               # Eski format test scripti
├── 📄 cleanup.ps1                   # Dosya temizleme scripti
└── 📄 API_DOCUMENTATION.md          # Bu dosya
```

---

## 🚀 Kurulum ve Başlatma

### 1. Gereksinimler

- Python 3.8+
- Google Gemini API anahtarı
- PowerShell (Windows)

### 2. Kurulum

```powershell
# Virtual environment oluştur (eğer yoksa)
python -m venv .venv

# Bağımlılıkları yükle
.\.venv\Scripts\pip install fastapi uvicorn python-dotenv google-generativeai requests
```

### 3. API Anahtarı Ayarla

`main/.env` dosyasını düzenle:
```
GEMINI_API_KEY=your_api_key_here
```

### 4. Sunucuları Başlat

**Terminal 1 - Main Sunucu:**
```powershell
cd main
..\.venv\Scripts\python.exe main_receiver.py
```

**Terminal 2 - Port Yönetimi:**
```powershell
cd "port-yönetimi"
..\.venv\Scripts\python.exe local_api_server.py
```

### 5. Web Arayüzünü Aç

```powershell
start web-ui\chatbot.html
```

---

## 📡 API Endpoint'leri

### 1. `/agent_config` - Agent Konfigürasyonu Kaydet

**Method:** `POST`  
**Port:** 9000 (direkt) veya 8000 (proxy üzerinden)  
**Açıklama:** Dashboard'dan gelen agent konfigürasyonunu kaydeder.

**İstek Formatı:**
```json
{
  "agentId": "agent_8823_xyz",
  "persona_title": "Premium Müşteri Temsilcisi",
  "model_instructions": {
    "tone": "Resmi, Saygılı ve Çözüm Odaklı",
    "rules": [
      "Cevaplar 4 cümleyi geçmemelidir.",
      "Fiyatlar hakkında savunmacı değil, değer odaklı konuşulmalıdır.",
      "Tüm cevaplar 'Saygılarımla.' ile bitmelidir."
    ],
    "prohibited_topics": ["Rakiplerin fiyatları", "Siyasi görüşler"]
  },
  "initial_context": {
    "company_slogan": "Kalite Asla Tesadüf Değildir.",
    "pricing_rationale": "Yüksek fiyatlandırmamız, birinci sınıf malzemeler ve kapsamlı garanti hizmetlerimizle ilişkilidir."
  }
}
```

**Yanıt Formatı:**
```json
{
  "status": "success",
  "agent_id": "agent_8823_xyz",
  "message": "Konfigürasyon kaydedildi"
}
```

---

### 2. `/chat` - Sohbet Mesajı Gönder

**Method:** `POST`  
**Port:** 9000 (direkt) veya 8000 (proxy üzerinden)  
**Açıklama:** Chat Core'dan gelen mesajı işler ve AI yanıtı döner.

**İstek Formatı:**
```json
{
  "agent_id": "agent_8823_xyz",
  "session_id": "sess_user_999",
  "user_message": "Fiyatlarınız neden bu kadar yüksek?",
  "chat_history": [
    {
      "role": "user",
      "content": "Merhaba"
    },
    {
      "role": "assistant",
      "content": "Merhaba! Size nasıl yardımcı olabilirim?"
    }
  ]
}
```

**Yanıt Formatı:**
```json
{
  "status": "success",
  "reply": "Değerli müşterimiz, fiyatlandırmamız kalite standartlarımıza göre belirlenmiştir...",
  "metadata": {
    "topic_detected": "fiyat_itirazi",
    "tokens_used": 850,
    "blocked": false,
    "agent_id": "agent_8823_xyz",
    "session_id": "sess_user_999"
  }
}
```

**Metadata Açıklamaları:**
- `topic_detected`: Tespit edilen konu
  - `fiyat_itirazi`: Fiyat, ücret, para, maliyet
  - `garanti_sorgusu`: Garanti, destek, servis
  - `urun_bilgisi`: Ürün, kalite, malzeme
  - `genel`: Diğer konular
- `tokens_used`: Kullanılan token sayısı (maliyet takibi)
- `blocked`: Yasaklı konu tespit edildiyse `true`

---

### 3. `/persona` - Eski Format (Geriye Dönük Uyumluluk)

**Method:** `POST`  
**Açıklama:** Eski persona formatını destekler.

**İstek Formatı:**
```json
{
  "name": "Yardımcı Asistan",
  "tone": "Arkadaş canlısı",
  "constraints": "Kısa cevaplar ver"
}
```

---

## 🗄️ Veritabanı Yapısı

### `agent_configurations` Tablosu

| Alan | Tip | Açıklama |
|------|-----|----------|
| id | INTEGER | Primary Key |
| agent_id | TEXT | Unique, Agent ID |
| persona_title | TEXT | Agent başlığı |
| tone | TEXT | Konuşma tonu |
| rules | TEXT | Kurallar (satır satır) |
| prohibited_topics | TEXT | Yasaklı konular (virgülle ayrılmış) |
| initial_context | TEXT | Başlangıç bağlamı |
| created_at | TEXT | Oluşturulma zamanı |
| updated_at | TEXT | Güncellenme zamanı |

### `personas` Tablosu (Eski Format)

| Alan | Tip | Açıklama |
|------|-----|----------|
| id | INTEGER | Primary Key |
| name | TEXT | Persona adı |
| tone | TEXT | Konuşma tonu |
| constraints | TEXT | Kısıtlamalar |
| created_at | TEXT | Oluşturulma zamanı |

---

## 🧪 Test Etme

### Yeni Format Testi (Önerilen)
```powershell
.\test_new_format.ps1
```

Bu test:
1. Agent konfigürasyonu kaydeder
2. İlk mesajı gönderir
3. Geçmişli ikinci mesajı gönderir
4. Kuralları ve metadata'yı kontrol eder

### Eski Format Testi
```powershell
.\test_system.ps1
```

### Web Arayüzü ile Test
```powershell
start web-ui\chatbot.html
```

---

## 🔄 Veri Akışı Senaryoları

### Senaryo 1: Dashboard → Agent Config
```
Dashboard
    ↓ POST /send_json
Port Yönetimi (8000)
    ↓ endpoint: /agent_config
Main Sunucu (9000)
    ↓ UPSERT
Database (agent_configurations)
```

### Senaryo 2: Chat Core → Sohbet
```
Chat Core
    ↓ POST /send_json
Port Yönetimi (8000)
    ↓ endpoint: /chat
Main Sunucu (9000)
    ↓ SELECT agent config
Database
    ↓ Build prompt with history
Gemini API
    ↓ AI response
Main Sunucu (9000)
    ↓ Add metadata
Chat Core (reply + metadata)
```

### Senaryo 3: Web Arayüzü
```
Web Arayüzü (chatbot.html)
    ↓ POST /chat (direkt)
Main Sunucu (9000)
    ↓ Process & call Gemini
Gemini API
    ↓ AI response
Main Sunucu (9000)
    ↓ reply + metadata
Web Arayüzü (display)
```

---

## 🎨 Web Arayüzü Özellikleri

- **Modern Tasarım**: Gradient renkler, smooth animasyonlar
- **Türkçe Karakter Desteği**: UTF-8 encoding
- **Typing Indicator**: AI düşünürken animasyon
- **Metadata Gösterimi**: Konu, token, durum bilgisi
- **Chat History**: Otomatik sohbet geçmişi yönetimi
- **Responsive**: Mobil ve masaüstü uyumlu

Detaylı bilgi için: `web-ui/README.md`

---

## 🔧 Yapılandırma

### Gemini Model Değiştirme

`main/main_receiver.py` dosyasında:
```python
model = genai.GenerativeModel("models/gemini-2.5-flash")
```

Mevcut modelleri görmek için:
```powershell
.\.venv\Scripts\python.exe .\list_models.py
```

### CORS Ayarları

Production'da `main/main_receiver.py` dosyasında:
```python
app.add_middleware(
    CORSMiddleware,
    allow_origins=["https://yourdomain.com"],  # Spesifik domain
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

---

## 🐛 Sorun Giderme

### API Anahtarı Hatası
```
GEMINI_API_KEY .env'de yok
```
**Çözüm**: `main/.env` dosyasına API anahtarını ekle.

### CORS Hatası
```
Access to fetch at 'http://localhost:9000/chat' has been blocked by CORS policy
```
**Çözüm**: Main sunucuyu yeniden başlat, CORS middleware aktif olmalı.

### Model Bulunamadı
```
404 models/gemini-pro is not found
```
**Çözüm**: `list_models.py` ile mevcut modelleri kontrol et ve güncelle.

### Port Kullanımda
```
Address already in use
```
**Çözüm**: Eski sunucu process'ini kapat veya farklı port kullan.

---

## 📊 Performans ve Limitler

### Gemini API Limitleri (Free Tier)
- **Requests per minute**: 15
- **Requests per day**: 1,500
- **Tokens per minute**: 1,000,000

### Öneriler
- Token kullanımını `metadata.tokens_used` ile takip et
- Uzun chat history'leri sınırla (son 10 mesaj)
- Rate limiting ekle (production için)

---

## 🔐 Güvenlik Önerileri

1. **API Anahtarı**: `.env` dosyasını `.gitignore`'a ekle
2. **CORS**: Production'da spesifik origin kullan
3. **Input Validation**: Pydantic models ile validasyon ekle
4. **Rate Limiting**: FastAPI-Limiter kullan
5. **HTTPS**: Production'da SSL sertifikası kullan

---

## 📝 Geliştirme Notları

### Yapılacaklar
- [ ] Pydantic models ile input validation
- [ ] Rate limiting middleware
- [ ] Logging sistemi
- [ ] Admin paneli
- [ ] Analytics dashboard
- [ ] Multi-language support

### Bilinen Sorunlar
- PowerShell'de Türkçe karakter encoding sorunu (web arayüzünde yok)
- Chat history sınırlaması yok (tüm geçmiş gönderiliyor)

---

## 📞 Destek

Sorularınız için:
- API Dokümantasyonu: Bu dosya
- Web UI Kılavuzu: `web-ui/README.md`
- Test Scriptleri: `test_new_format.ps1`, `test_system.ps1`

---

## 📄 Lisans

Bu proje eğitim amaçlı geliştirilmiştir.

---

**Son Güncelleme**: 2025-12-17  
**Versiyon**: 1.0.0
