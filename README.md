ไฟล์ README สำหรับผลงาน Testing API
ยินดีต้อนรับสู่คู่มือการใช้งาน API และการรันเทสสำหรับโปรเจค Testing API! ดังนี้คือขั้นตอนที่คุณต้องทำเพื่อเริ่มต้นใช้งาน API และรันเทส:

การเปิด API

1. เข้าสู่โฟลเดอร์ของ API:
   bash
   cd path/to/api_directory_1

2. เปิด Command Prompt (หรือ Terminal สำหรับ macOS หรือ Linux).

3. พิมพ์คำสั่งเพื่อเริ่มเซิร์ฟเวอร์ API:
   java -jar doppio_api.jar
   เมื่อเซิร์ฟเวอร์ API ได้เริ่มการทำงานแล้ว คุณจะเห็นข้อความที่บอกว่าเซิร์ฟเวอร์ถูกเปิดที่พอร์ตใด ๆ เช่น Spring

การรันเทสด้วย Robot Framework

1. เปิด Command Prompt (หรือ Terminal สำหรับ macOS หรือ Linux).

2. เข้าสู่โฟลเดอร์ของ API สำหรับเทส:
   bash
   cd path/to/api_directory_2

3. ใช้คำสั่งต่อไปนี้เพื่อรันเทสด้วย Robot Framework:
   robot name_of_your_test_file.robot
4. Robot Framework จะเริ่มทำการทดสอบตามที่ได้กำหนดไว้ในไฟล์เทส
