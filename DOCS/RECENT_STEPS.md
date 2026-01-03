# Son İki Adım — Özet

**Amaç**
- Kullanıcı tarafından gönderilen `chat_history` parametresinin kaldırılması ve sohbet geçmişinin sunucuda authoritative (güvenilir) şekilde saklanması.
- Sohbet geçmişinin tamamını doğrudan prompt içine koymaktan kaçınarak prompt token maliyetini ve prompt-injection riskini azaltmak; bunun yerine kompakt, sanitize edilmiş bir özet kullanmak.

**Yapılan Değişiklikler (yüksek seviye)**
1. Server-side history (client-provided history iptal edildi)
   - Artık frontend `chat_history` göndermiyor; backend gelen `chat_history` parametresini yok sayıyor.
   - Backend, her session için gelen kullanıcı ve model cevaplarını veritabanına kaydediyor.
   - Yeni helper fonksiyonlar eklendi: `save_chat_message(session_id, agent_id, role, message)` ve `get_chat_history(session_id, agent_id, limit)`.

2. Kompakt ve sanitize geçmiş oluşturma
   - `get_compact_history(session_id, agent_id, ...)` fonksiyonu eklendi.
   - Fonksiyon yalnızca son N mesajı alır (varsayılan: 6), mesajları temizler (üçlü tırnak, görünür sistem metinleri vb.), uzun mesajları kısaltır ve eğer eski mesajlar varsa kısa bir uyarı ekler.
   - Prompt oluşturma kısmı artık ham geçmiş yerine `get_compact_history(...)` çıktısını ekliyor.

**Etkilenen dosyalar**
- `main/main_receiver.py`
  - Veritabanı `chat_history` tablosuna `session_id` ve `agent_id` sütunları eklendi (migrasyon gerekebilir).
  - `save_chat_message`, `get_chat_history`, `get_compact_history` fonksiyonları eklendi.
  - `chat` endpoint: client tarafından gelen `chat_history` artık kullanılmıyor; server-side geçmiş alınarak prompt hazırlanıyor ve model cevabından sonra kullanıcı+assistant mesajları veritabanına kaydediliyor.
- `web-ui/chatbot.html`
  - Artık `fetch` isteğinde `chat_history` gönderilmiyor; sadece `agent_id`, `session_id` ve `user_message` gönderiliyor.

**Neden bu değişiklikler yapıldı?**
- Güvenlik: Client tarafından gönderilen geçmişin manipülasyonu prompt injection riski yaratıyordu.
- Performans/ölçeklenebilirlik: Tam geçmişin prompt içinde gönderilmesi token maliyetini artırır; modeli ve maliyeti kontrol edilebilir tutmak için kısa bir özet daha güvenli.

**Test/Doğrulama Adımları**
1. Container'ı yeniden build & run:
```powershell
docker build -t kremna:latest -f dockerfile .
docker run --rm -p 8080:8080 -e PORT=8080 --name kremna_app kremna:latest
```
2. Web UI'yi açın: `http://localhost:8080/` — mesaj gönderin ve tarayıcı konsolunda herhangi bir `chat_history` gönderilip gönderilmediğini kontrol edin (Network tab).
3. Veritabanında kayıtları kontrol edin (örnek SQLite):
```powershell
sqlite3 personas.db "SELECT session_id, agent_id, role, substr(message,1,120) as snippet, timestamp FROM chat_history ORDER BY id DESC LIMIT 20;"
```
4. Uzun geçmişli bir konuşma simüle ederek model prompt token sayısında azalma gözlemleyin (hem loglarda hem de model token hesaplamasında görülebilir).

**Notlar / Geçiş (migration) uyarısı**
- Eğer mevcut veritabanında `chat_history` tablosu eski şemadaysa (yeni sütunlar yoksa), basit bir migration gerekir. Alternatif olarak yeni bir DB oluşturulabilir. Migration örneği:
  - SQLite: `ALTER TABLE chat_history ADD COLUMN session_id TEXT;` ve `ALTER TABLE chat_history ADD COLUMN agent_id TEXT;`
  - Postgres: `ALTER TABLE chat_history ADD COLUMN session_id VARCHAR(255);` ve `ALTER TABLE chat_history ADD COLUMN agent_id VARCHAR(255);`

**Gelecek geliştirme önerileri**
- `get_compact_history` fonksiyonunu bir özetleme modeli ile değiştirip (örn. kısa bir embedding/abstractive özet) daha iyi anlam sağlayan kısa özetler üretilebilir. Bu, daha güçlü prompt-injection koruması ve daha küçük promptler sağlar.

---
Bu dosya, son iki adımda yapılan değişiklikleri hızlıca anlamanız için hazırlandı. İsterseniz ben şimdi migration script'ini otomatik ekleyeyim veya `get_compact_history`'i daha sofistike bir özetleme çağrısı ile değiştiririm.