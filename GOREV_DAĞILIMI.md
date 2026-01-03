# Görev Dağılımı ve Kod Katkıları

Aşağıda, proje dosyalarında hangi kısımların hangi takım üyesi tarafından yazıldığı belirtilmiştir. Kodlarda da ilgili yerlere açıklama satırı olarak eklenmiştir.

---

## main/main_receiver.py

- **API endpoint’lerinin oluşturulması**  
  *Backend Developer*  
  `# YAZAN: Backend Developer`

- **Veritabanı bağlantısı ve modeller**  
  *Backend Developer*  
  `# YAZAN: Backend Developer`

- **init_db ve /chat endpoint bakimi**  
  *Melike*  
  `# YAZAN: Melike`

- **Google Gemini API entegrasyonu**  
  *Backend Developer*  
  `# YAZAN: Backend Developer`

- **Agent ve persona yönetimi ile ilgili fonksiyonlar**  
  *Product Manager (iş akışı), Backend Developer (kod)*  
  `# YAZAN: Product Manager & Backend Developer`

---

## port-yönetimi/local_api_server.py

- **Yardımcı FastAPI sunucusu kurulumu**  
  *DevOps*  
  `# YAZAN: DevOps`

- **JSON veri iletimi fonksiyonları**  
  *Backend Developer*  
  `# YAZAN: Backend Developer`

---

## web-ui/chatbot.html

- **HTML iskeleti ve temel yapı**  
  *Frontend Developer*  
  `<!-- YAZAN: Frontend Developer -->`

- **Arayüz tasarımı ve stil dosyaları**  
  *UI Designer*  
  `<!-- YAZAN: UI Designer -->`

- **Kullanıcıya gösterilen metinler ve açıklamalar**  
  *UX Writer*  
  `<!-- YAZAN: UX Writer -->`

- **Agent seçimi ve mesajlaşma akışı**  
  *Frontend Developer*  
  `<!-- YAZAN: Frontend Developer -->`

---

## requirements.txt

- **Bağımlılıkların listelenmesi**  
  *Backend Developer & DevOps*  
  `# YAZAN: Backend Developer & DevOps`

---

## agent_8823_config.json, test_agent_config.json

- **Agent persona ve kurallarının tanımlanması**  
  *Product Manager & UX Writer*  
  `// YAZAN: Product Manager & UX Writer`

---

## Ekstra

- **Kullanıcı test senaryoları ve test scriptleri**  
  *QA Engineer*  
  `# YAZAN: QA Engineer`


---

Kodlarda örnek kullanım:

Python:
```python
# YAZAN: Backend Developer
@app.post("/chat")
async def chat_endpoint(request: ChatRequest):
    ...
```

HTML:
```html
<!-- YAZAN: UI Designer -->
<div class="chat-window">
    ...
</div>
```

JSON:
```json
// YAZAN: Product Manager & UX Writer
{
  "agent_name": "Kremna",
  ...
}
```

---

Her dosyada ve önemli kod bloğunda bu şekilde yorum satırı ile katkı sahibi belirtilmiştir.