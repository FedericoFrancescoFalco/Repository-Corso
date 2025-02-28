mkdir cercastringa
cp cerca.py ./cercastringa
cp requirements.txt ./cercastringa
cd cercastringa
pip3 install virtualenv
virtualenv myenv
source myenv/bin/activate
pip3 install -r requirements.txt