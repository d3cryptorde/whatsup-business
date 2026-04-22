// Inject.js
// JavaScript bridge to interact with WhatsApp Web internal API

window.WPP = window.WPP || {};

(function() {
    console.log("WhatsApp Bridge Injected");

    function findStore() {
        if (window.Store) return window.Store;
        
        const modules = window.webpackChunkwhatsapp_web_client;
        if (!modules) return null;

        // Try to find the Store module
        // This is a simplified version; real-world implementation might need more robust module discovery
        return window.Store;
    }

    window.WhatsAppBridge = {
        isReady: false,
        
        init: function() {
            const checkReady = setInterval(() => {
                const store = findStore();
                if (store && store.Chat && store.Msg) {
                    this.isReady = true;
                    clearInterval(checkReady);
                    console.log("WhatsApp Bridge Ready");
                    window.webkit.messageHandlers.bridgeReady.postMessage({status: "ready"});
                    this.setupEvents();
                }
            }, 1000);
        },

        setupEvents: function() {
            window.Store.Msg.on('add', (msg) => {
                if (msg.isNewMsg && !msg.id.fromMe) {
                    window.webkit.messageHandlers.newMessage.postMessage({
                        id: msg.id._serialized,
                        body: msg.body,
                        from: msg.from._serialized,
                        senderName: msg.sender ? msg.sender.pushname : "Unknown"
                    });
                }
            });
        },

        sendMessage: function(chatId, body) {
            const chat = window.Store.Chat.get(chatId);
            if (chat) {
                chat.sendMessage(body);
                return true;
            }
            return false;
        },

        getQRCode: function() {
            const canvas = document.querySelector('canvas');
            if (canvas) {
                return canvas.toDataURL();
            }
            return null;
        }
    };

    window.WhatsAppBridge.init();
})();
