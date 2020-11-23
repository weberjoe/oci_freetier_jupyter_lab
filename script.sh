#!/bin/bash
echo "- start install script -"

# python, pip & jupyter dependencies
sudo apt-get update -y
sudo apt install -y python3 python3-pip python3-dev curl
pip3 install pandas numpy seaborn
sudo apt install -y ipython
pip3 install jupyter jupyterlab

export PATH=$PATH:~/.local/bin
source ~/.bashrc

# jupyter setup
sudo mkdir /home/ubuntu/jupyter
sudo chown -R ubuntu: /home/ubuntu/jupyter/
jupyter notebook --generate-config -y

# append lines to config jupyter config path:
JUPY_CONF_PATH="/home/ubuntu/.jupyter/jupyter_notebook_config.py"
echo "# Enable Jupyter to accept connection from outside the host running it" >> $JUPY_CONF_PATH
echo "c.NotebookApp.allow_remote_access = True" >> $JUPY_CONF_PATH
echo "# Accept connection come from any source" >> $JUPY_CONF_PATH
echo "c.NotebookApp.ip = '*'" >> $JUPY_CONF_PATH
echo "# Do not open a browser (as there isn't any and it's a remote setup)" >> $JUPY_CONF_PATH
echo "c.NotebookApp.open_browser = False" >> $JUPY_CONF_PATH
echo "# Use this folder as 'root' folder for the notebooks (need to create it)" >> $JUPY_CONF_PATH
echo "c.NotebookApp.notebook_dir = u'/home/ubuntu/jupyter'" >> $JUPY_CONF_PATH
echo "# Instead of a random token, use this password as login" >> $JUPY_CONF_PATH
echo "c.NotebookApp.password = u'argon2:\$argon2id\$v=19\$m=10240,t=10,p=8\$2Tafc3V0/HwEklmlInJmPw\$QZ26R0cQzFRSs3NGqybroQ'" >> $JUPY_CONF_PATH

echo "- finish install script -"