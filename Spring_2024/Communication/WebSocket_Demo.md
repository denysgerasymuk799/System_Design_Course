# WebSocket Demo

The below code snippets are based on [the "WebSockets in FastAPI" guide](https://fastapi.tiangolo.com/advanced/websockets/).

Client:
```html
<!DOCTYPE html>
<html>
<head>
    <title>Chat</title>
</head>
<body>
    <h1>WebSocket with FastAPI</h1>
    <form action="" onsubmit="sendMessage(event)">
        <input type="text" id="messageText" autocomplete="off" />
        <button>Send</button>
    </form>
    <ul id='messages'>
    </ul>
    <script>
        var ws = new WebSocket(`ws://localhost:5000/communicate`);
        console.log("Connected")
        ws.onmessage = function (event) {
            var messages = document.getElementById('messages')
            var message = document.createElement('li')
            var content = document.createTextNode(event.data)
            message.appendChild(content)
            messages.appendChild(message)
        };
        console.log("Send Mesage")
        function sendMessage(event) {
            var input = document.getElementById("messageText")
            ws.send(input.value)
            input.value = ''
            event.preventDefault()
        }
    </script>
</body>
</html>
```

Server:
```python
from fastapi import FastAPI, WebSocket

app = FastAPI()

manager = ConnectionManager()

@app.websocket("/communicate")
async def websocket_endpoint(websocket: WebSocket):
    await manager.connect(websocket)
    try:
        while True:
            data = await websocket.receive_text()
            await manager.send_personal_message(f"Message text was: {data}")
    except WebSocketDisconnect:
        manager.disconnect(websocket)
        await manager.send_personal_message("Bye!!!",websocket)
```
