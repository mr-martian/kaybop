from flask import Flask, request, render_template
import os
import subprocess

base_dir = os.path.dirname(__file__)
app = Flask('kaybop',
            static_folder=os.path.join(base_dir, 'static'),
            static_url_path='/static',
            template_folder=os.path.join(base_dir, 'templates'))

def lookup(s, fst):
    proc = subprocess.run(['hfst-lookup', fst], capture_output=True,
                          encoding='utf-8', input=s)
    ret = []
    for l in proc.stdout.splitlines():
        ls = l.split()
        if len(ls) > 2:
            ret.append(ls[-2])
    return ret

def conjugate(s):
    conj = (lookup(s, 'kaybop_gen.hfstol') or ['(invalid)'])[0]
    unconj = lookup(conj, 'kaybop_morf.hfstol')
    return render_template('conj.html', inp=s, conj=conj, unconj=unconj)

@app.route('/')
def main_page():
    return render_template('index.html')

def to_tag(s):
    if not s:
        return ''
    return '<' + s.replace('.', '><') + '>'

@app.route('/verb', methods=['POST'])
def verb():
    s = ''
    for prn in ['nom', 'acc', 'dat']:
        if request.form.get(prn, 'none') != 'none':
            s += to_tag(request.form[prn]) + f'<{prn}>+'
    s += request.form['lemma']
    s += '<v>'
    for tag in ['number', 'expectation', 'mental', 'day', 'truth', 'awe']:
        s += to_tag(request.form.get(tag, ''))
    s += '±' + request.form.get('error', '') + '%'
    return conjugate(s)

@app.route('/noun', methods=['POST'])
def noun():
    s = request.form['lemma']
    if s.startswith('<p'):
        s += '<prn>'
    else:
        s += '<n>'
    for tag in ['case', 'number', 'expectation', 'edible', 'gender', 'death', 'awe']:
        s += to_tag(request.form.get(tag, ''))
    if request.form.get('log') == 'on':
        s += 'LOG'
    s += request.form.get('value', '')
    return conjugate(s)

@app.route('/adj', methods=['POST'])
def adj():
    s = request.form['lemma'] + '<adj>' + request.form['stddev']
    return conjugate(s)

@app.route('/other', methods=['POST'])
def other():
    s = request.form['lemma']
    if s.isdigit():
        if int(s[-1]) % 2 == 0:
            s += '<num><even>'
        else:
            s += '<num><odd>'
    return conjugate(s)
