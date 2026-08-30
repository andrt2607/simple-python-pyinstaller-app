'''
Simple Flask web UI for the 'calc' library's 'add2' function.
'''

from flask import Flask, render_template, request
import calc

app = Flask(__name__)


@app.route('/', methods=['GET', 'POST'])
def index():
    result = None
    if request.method == 'POST':
        val1 = request.form.get('value1', '')
        val2 = request.form.get('value2', '')
        result = calc.add2(val1, val2)
    return render_template('index.html', result=result)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
