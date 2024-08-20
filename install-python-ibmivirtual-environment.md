# IBM i Example to Create a Python Virtual Environment in PASE

# Make sure the IBM i environment is set up for Python development

### Install the Development Group Tools (gcc, git, cmake, tar etc.)   
``` yum group install 'Development tools' ```   
### Install Python 3.6 and Python 3.9 Packeges   
``` yum install python3* ```   

# Make Python virtual environment directory
This example creates /pythonenv1   
```mkdir /pythonenv1```

# Create a virtual environment

## Create virtual environment with site packages (Recommended)
It's a good idea to install with the site packages for IBM i because your get all the base packages installed via yum. Plus you can still install specific Python pip packages in the virtual environment  (venv).    
```python3 -m venv /pythonenv1 --system-site-packages --copies```

:star: This will include ibm-db which installs via the python3 based yum packages.

### You can also specifically set up the environment to use Python 3.6 or 3.9
```python3.6 -m venv /pythonenv1 --system-site-packages --copies```   
```python3.9 -m venv /pythonenv1 --system-site-packages --copies```   

## Create virtual environment without site packages 
You can still install packages in the venv except for ibm-db which installs as a site package. SO if you don't need any of the yum-based Python packages this method can be used if desired.    
```python3 -m venv /pythonenv1```

# Activate the Python environment   
```source /pythonenv1/bin/activate```

# Command prompt after activation   
```(pythonenv1) -bash-5.1$``` 

# List installed packages 
This command works in the based Python environment or an active virtual environment.  
```pip3 list```

Example package list:   
```
Package    Version
---------- -------
pip        22.0.4
setuptools 58.1.0
```

# Installing Python packages   

```Pre V7R4``` you can simply install with pip3 command. gcc is used which is gcc v6.x.   
```
pip3 install pyodbc
pip3 install flask
pip3 install itoolkit
pip3 install ibm-db
```

```For V7R4 and V7R5``` - pip3 processes require gcc10 compiler to build so use CC/GCC prefixes below for installing pip3 packages. Or set the CC and CXX environment variable before installing packages with pip3.    
```CC='gcc-10 -pthread' CXX='g++-10 -pthread'  pip3 install pyodbc```   
```CC='gcc-10 -pthread' CXX='g++-10 -pthread'  pip3 install flask```

Or export CC and CXX as an environment variable and then run pip3 stuff. 
(Could also add the export of CC and CXX to your .bash_profile or .bashrc file)   
```export CC='gcc-10 -pthread' CXX='g++-10 -pthread'```   

After exporting the CC and CXX variables, install your pip3 packages   
```
pip3 install pyodbc
pip3 install flask
```

# Run any python stuff 
Run any of your scripts or pip3 installs. 

# Deactivate Python venv
```deactivate ```

# Misc - creating a custom gcc link for gcc10
```
mkdir mydir
ln -s /QOpenSys/pkgs/bin/gcc-10 mydir/gcc
ln -s /QOpenSys/pkgs/bin/g++-10 mydir/g++
PATH=$PWD/mydir:$PATH
```
:star: Note: You may want to create above links in ~/bin directory instead of mydir. I have not tried this but it was recommended as something to try. I think just setting the CC and CXX environment variables should work fine.

# Misc - Running your Python script from a classic IBM i job
This example runs a Python script named: **hello.py** from the /python directory using virtual environment **/pythonenv1** and the **QSHPYRUN** command which is part of the QShell on i utilities. https://github.com/richardschoen/qshoni      
```
QSHONI/QSHPYRUN SCRIPTDIR('/python')         
                SCRIPTFILE(hello.py)                         
                PYVERSION(3.9)                                    
                VENVPATH('/pythonenv1')                           
                DSPSTDOUT(*YES)                                   
```                                                                  
