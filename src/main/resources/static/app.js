const connectWebSocket = (token) => {
    const socket = new SockJS('http://localhost:8080/ws?token=' + token);
    const stompClient = Stomp.over(socket);

    stompClient.connect({}, function (frame) {
        console.log('Connected: ' + frame);

        // Đăng ký nhận tin nhắn cho user
        if (currentUser.role === 'USER') {
            stompClient.subscribe('/queue/user.' + currentUser.id, function (message) {
                const messageData = JSON.parse(message.body);
                console.log('Received message:', messageData);
                displayMessage(messageData);
            });
        }

        // Đăng ký nhận tin nhắn cho tasker
        if (currentUser.role === 'TASKER') {
            stompClient.subscribe('/queue/tasker.' + currentUser.id, function (message) {
                const messageData = JSON.parse(message.body);
                console.log('Received message:', messageData);
                displayMessage(messageData);
            });
        }

        // Lưu stompClient để sử dụng sau này
        window.stompClient = stompClient;
    }, function (error) {
        console.log('Connection error: ' + error);
        // Thử kết nối lại sau 5 giây nếu token hết hạn
        setTimeout(() => {
            refreshTokenAndConnect();
        }, 5000);
    });
};

// Hàm gửi tin nhắn
const sendMessage = (roomId, message) => {
    if (!window.stompClient || !window.stompClient.connected) {
        console.error('WebSocket không được kết nối');
        return;
    }

    const chatMessage = {
        roomId: roomId,
        senderType: currentUser.role === 'USER' ? 'user' : 'tasker',
        senderId: currentUser.id,
        messageText: message
    };

    window.stompClient.send('/app/chat.sendMessage', {}, JSON.stringify(chatMessage));
};

// Hàm làm mới token và kết nối lại
const refreshTokenAndConnect = async () => {
    try {
        const response = await fetch('/api/auth/refresh-token', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                refreshToken: localStorage.getItem('refreshToken')
            })
        });

        if (response.ok) {
            const data = await response.json();
            localStorage.setItem('token', data.accessToken);
            connectWebSocket(data.accessToken);
        } else {
            console.error('Không thể làm mới token');
            // Chuyển hướng đến trang đăng nhập
            window.location.href = '/login';
        }
    } catch (error) {
        console.error('Lỗi khi làm mới token:', error);
    }
};
