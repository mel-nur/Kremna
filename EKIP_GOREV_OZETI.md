# Ekip Görev Özeti ve İş Dağılımı

## 1. Backend Developer
**Görev:** API endpoint'leri, iş mantığı, Gemini entegrasyonu, prompt optimizasyonu

**Kodladığı Bölümler:**
- `main/main_receiver.py`
  - **Satır 10-25:** FastAPI imports ve temel yapı
  - **Satır 51-69:** Pydantic modeller (ModelInstructions, AgentConfigRequest)
  - **Satır 71-81:** CORS middleware konfigürasyonu
  - **Satır 287-330:** `get_compact_history()` fonksiyonu (QA Engineer ile paylaşımlı) - prompt optimizasyonu
  - **Satır 486-539:** `/persona` endpoint (UX Writer ile paylaşımlı)
  - **Satır 540-605:** `/agent_config` endpoint (Product Manager & UX Writer ile paylaşımlı)
  - **Satır 614-905:** `/chat` endpoint (QA Engineer & UX Writer ile paylaşımlı)
    - Kompakt geçmiş yükleme (satır 778-782)
    - Model çağrısı ve yanıt işleme (satır 822-850)
  - **Satır 912-914:** Uvicorn server başlatma

**Toplam Sorumluluk:** ~330 satır

---

## 2. DevOps
**Görev:** Deployment, ortam yönetimi, veritabanı altyapısı, chat geçmişi persist

**Kodladığı Bölümler:**
- `main/main_receiver.py`
  - **Satır 40-49:** `.env` dosya yükleme mantığı
  - **Satır 96-132:** Veritabanı yönetimi
    - `get_db_connection()` fonksiyonu
    - `ph()` placeholder fonksiyonu
  - **Satır 132-254:** `init_db()` fonksiyonu (DB tablo oluşturma, demo agent ekleme)
  - **Satır 257-286:** Chat history storage fonksiyonları
    - `save_chat_message()`
    - `get_chat_history()`
  - **Satır 766-776:** Gemini API key yükleme ve konfigürasyon
  - **Satır 880-895:** Chat history kaydetme
- `dockerfile` (tüm dosya ~15 satır)
- `port-yönetimi/local_api_server.py`
  - **Satır 18-23:** Port ve URL konfigürasyonu
  - **Satır 52-54:** Uvicorn server başlatma
- `requirements.txt` (tüm dosya)
- `.env` (örnek/şablon)

**Toplam Sorumluluk:** ~290 satır

---

## 3. Frontend Developer
**Görev:** Kullanıcı arayüzü, mesajlaşma akışı, JavaScript mantığı

**Kodladığı Bölümler:**
- `web-ui/chatbot.html`
  - **Satır 420-442:** Global değişkenler ve DOM elementleri
  - **Satır 443-487:** `addMessage()` fonksiyonu
  - **Satır 488-509:** `showTypingIndicator()` fonksiyonu
  - **Satır 510-520:** `hideTypingIndicator()` fonksiyonu
  - **Satır 521-591:** `sendMessage()` fonksiyonu (ana mesajlaşma)
  - **Satır 592-614:** `loadAgents()` fonksiyonu
  - **Satır 615-643:** `renderAgentList()` fonksiyonu
  - **Satır 644-667:** `selectAgent()` fonksiyonu
  - **Satır 668-676:** `openAgentModal()` fonksiyonu
  - **Satır 677-685:** `closeAgentModal()` fonksiyonu
  - **Satır 686-705:** Event listener'lar

**Toplam Sorumluluk:** ~285 satır (JavaScript)

---

## 4. UI Designer
**Görev:** Görsel tasarım, CSS, animasyonlar

**Kodladığı Bölümler:**
- `web-ui/chatbot.html`
  - **Satır 8-420:** Tüm CSS stilleri
    - Reset ve body stilleri
    - Chat container ve header
    - Mesaj balonları (user/assistant)
    - Typing indicator animasyonu
    - Modal tasarımı
    - Scrollbar özelleştirmesi
    - Responsive tasarım

**Toplam Sorumluluk:** ~410 satır (CSS)

---

## 5. QA Engineer
**Görev:** Güvenlik kontrolleri, test senaryoları, validasyon, metadata yönetimi

**Kodladığı Bölümler:**
- `main/main_receiver.py`
  - **Satır 648-680:** Prompt injection kontrolü (INJECTION_KEYWORDS listesi ve reddetme mantığı)
  - **Satır 850-861:** Yasaklı konu kontrolü (keyword matching)
  - **Satır 862-874:** Konu tespiti mantığı (Product Manager ile paylaşımlı)
  - **Satır 880-895:** Chat history kaydetme ve error handling (DevOps ile paylaşımlı)
  - **Satır 896-905:** Response metadata validation ve yapılandırma
  - Test senaryoları ve validation scriptleri (ayrı dosyalarda)

**Toplam Sorumluluk:** ~80 satır

---

## 6. UX Writer
**Görev:** Kullanıcı metinleri, sistem mesajları, promptlar, hata mesajları

**Kodladığı Bölümler:**
- `main/main_receiver.py`
  - **Satır 486-539:** `/persona` endpoint hata/başarı mesajları (Backend Developer ile paylaşımlı)
  - **Satır 540-605:** `/agent_config` endpoint mesajları (Backend Developer & Product Manager ile paylaşımlı)
  - **Satır 648-680:** Prompt injection reddetme mesajları (QA Engineer ile paylaşımlı)
  - **Satır 785-795:** SYSTEM_GUARD prompt metni
  - **Satır 796-820:** Agent prompt şablonu (rol, ton, kurallar, yasaklı konular)
  - **Satır 850-861:** Yasaklı konu reddetme mesajı
  - **Satır 880-905:** Tüm endpoint yanıt mesajları
- `web-ui/chatbot.html`
  - Placeholder metinler ("Mesajınızı yazın...")
  - Başlık ve açıklama metinleri
  - Hata mesajları
  - Modal içerikleri
- `agent_8823_config.json` ve diğer config dosyaları
  - Persona metinleri
  - Talimatlar

**Toplam Sorumluluk:** ~180 satır (kod içi) + config dosyaları

---

## 7. Product Manager
**Görev:** İş akışı, agent yönetimi, API şema tasarımı, fallback stratejisi

**Kodladığı Bölümler:**
- `main/main_receiver.py`
  - **Satır 386-484:** Agent listeleme ve detay endpoint'leri
    - `/agents` endpoint
    - `/agents/{agent_id}` endpoint
    - JSON parsing helper (`safe_parse_json`)
  - **Satır 540-605:** Agent config kaydetme endpoint'i (`/agent_config`)
  - **Satır 702-765:** Agent yükleme ve fallback mantığı
    - Demo-agent fallback
    - Legacy persona_id desteği
    - Agent config dict oluşturma
  - **Satır 862-874:** Konu tespiti (QA Engineer ile paylaşımlı)
- `agent_8823_config.json` ve diğer config dosyaları
- `GOREV_DAĞILIMI.md`, `RECENT_STEPS.md` (dokümantasyon)

**Toplam Sorumluluk:** ~240 satır (kod) + dokümantasyon

---

## İş Yükü Özeti (Satır Bazlı)

| Ekip Üyesi | Kod Satırı | Yüzde |
|------------|-----------|-------|
| UI Designer | ~410 | %22 |
| Backend Developer | ~330 | %18 |
| DevOps | ~290 | %16 |
| Frontend Developer | ~285 | %15 |
| Product Manager | ~240 | %13 |
| UX Writer | ~180 | %10 |
| QA Engineer | ~80 | %4 |

**Toplam:** ~1815 satır kod

**İş Yükü Dengesi:** %4-%22 arası (Maksimum fark: 18 puan)

---

## Notlar
- **DevOps** olarak birleştirildi ve iş yükü dengeli dağıtıldı
- Backend Developer'a prompt optimizasyonu (`get_compact_history`) eklendi (~280 → ~330 satır)
- DevOps  sadece DB ve storage'a odaklandı (~380 → ~290 satır)
- Product Manager'a agent fallback mantığı verildi (~180 → ~240 satır)
- UX Writer'da tüm kullanıcı mesajları (~180 satır)
- QA Engineer'da güvenlik ve validation (~80 satır)
- Frontend/UI ayrımı net
- **7 kişilik ekip, dengeli iş yükü: %4-22 arası, max fark 18 puan**

---

**Son Güncelleme:** 3 Ocak 2026
**Yazar:** Proje Koordinatörü
