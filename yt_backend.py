from flask import *
from pytube import YouTube
from threading import Thread
from os import system, path, remove, rename



app = Flask(__name__)

title = ""

def start_download(target_url):
    global status
    global target
    global title
    target = YouTube(target_url).streams.get_audio_only()
    target.download()
    old_name = target.title.replace("|", "") + ".mp4"
    new_name = target.title.replace("|", "") + ".mp3"
    rename(old_name, new_name)
    title = target.title + ".mp3"
    
    status = 1

    @app.route('/{}'.format(title), methods=['GET', 'POST'])
    def download():
        try:
            return send_file(title, as_attachment=True)
            remove(title)
        except:
            return "no downloads available"
    
    
@app.route('/', methods=['GET', 'POST'])
def home():
    return "home"

@app.route('/video', methods=['GET'])
def get_url():
    
    Thread(target=start_download(request.args.get('url'))).start()
    while 1:
        try:
            if (status == False):
                continue
            else:
                break
        except:
            pass
    return "http://192.168.43.77:1111/" + title

if (__name__ == "__main__"):
    system('cls')
    app.run(host='192.168.43.77', port=1111)