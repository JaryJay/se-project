ServerMessenger messenger = new ServerMessenger();

void setup() {
   size(400, 400);
   messenger.init();
}

void draw() {
   messenger.update();
}
