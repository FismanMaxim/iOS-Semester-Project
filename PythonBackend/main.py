from flask import Flask, jsonify
import random

app = Flask(__name__)

STUDY_TEXTS = [
    "Сосредоточься на задаче. Маленькие шаги каждый день — большой прогресс.",
    "Каждая минута учебы приближает тебя к цели!",
    "Ты можешь больше, чем думаешь! Продолжай в том же духе.",
    "Знания — это твоя суперсила. Развивай её!",
    "Сложности делают нас сильнее. Не сдавайся!"
]

REST_TEXTS = [
    "Отличная работа! Немного отдыха — и можно снова в бой.",
    "Заслуженный перерыв! Восстанови силы для новых свершений.",
    "Отдых — важная часть продуктивности. Наслаждайся моментом!",
    "Ты хорошо поработал! Теперь дай мозгу отдохнуть.",
]

@app.route('/api/motivation/study', methods=['GET'])
def get_study_motivation():
    return jsonify({'text': random.choice(STUDY_TEXTS)})

@app.route('/api/motivation/rest', methods=['GET'])
def get_rest_motivation():
    return jsonify({'text': random.choice(REST_TEXTS)})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)