# IBM i Example to Create a Python Virtual Environment in PASE

# Make sure the IBM i environment is set up for Python development

### Install the Development Group Tools (gcc, git, cmake, tar etc.)     
``` yum group install 'Development tools' ```   
### Install Unix ODBC Driver   
``` yum install unixODBC ```   
``` yum install unixODBC-devel ```   
### Install IBM i Access ODBC Driver   
``` yum install ibm-iaccess* ```   
### Install Python 3.6 and Python 3.9 Packages    
``` yum install python3* ```   

### List installed Python base site packages for Python 3.6   
Run following command to list base packages to see what pip packages are installed: **pip3.6  list**    
The list should look similar to the list below:     
```
Package         Version
--------------- --------
asn1crypto      0.24.0
bcrypt          3.1.4
cffi            1.11.5
cryptography    2.8
ibm-db          2.0.5.12
idna            2.8
itoolkit        1.6.1
Jinja2          2.11.2
lxml            4.2.1
MarkupSafe      1.1.1
numpy           1.15.4
pandas          0.22.0
paramiko        2.6.0
Pillow          5.0.0
pip             21.1.2
psutil          5.5.1
psycopg2        2.8.5
pycparser       2.19
PyNaCl          1.2.1
pyodbc          4.0.27
python-dateutil 2.8.0
pytz            2018.5
PyYAML          5.3.1
pyzmq           17.1.2
scikit-learn    0.19.1
scipy           1.1.0
setuptools      57.0.0
six             1.10.0
wheel           0.36.2
```

### List installed Python base packages for Python 3.9   
Run following command to list base packages to see what pip packages are installed: **pip3.9  list**    
The list should look similar to the list below:   
```
Package         Version
--------------- --------
bcrypt          3.2.0
beniget         0.4.1
cffi            1.14.5
cryptography    3.4.7
Cython          0.29.24
gast            0.5.3
ibm-db          2.0.5.15
itoolkit        1.7.0
joblib          1.1.0
lxml            4.6.3
numpy           1.21.4
pandas          1.3.4
paramiko        2.7.2
Pillow          8.3.1
pip             21.1.2
ply             3.11
psutil          5.8.0
psycopg2        2.9.1
pybind11        2.8.1
pycparser       2.20
PyNaCl          1.4.0
pyodbc          4.0.31
python-dateutil 2.8.1
pythran         0.10.0
pytz            2021.1
pyzmq           22.1.0
scikit-learn    1.0.1
scipy           1.7.3
setuptools      57.0.0
six             1.16.0
threadpoolctl   3.0.0
wheel           0.36.2
```

# Make Python virtual environment directory
This example creates /pythonenv1   
```mkdir /pythonenv1```

# Create a virtual environment

## Create virtual environment with site packages (Recommended)
It's a good idea to install with the site packages for IBM i because your get all the base packages installed via yum. Plus you can still install specific Python pip package versions in the virtual environment  (venv).    
```python3 -m venv /pythonenv1 --system-site-packages --copies```  (Installs using default version of Python3.)   
### You can also specifically set up the new virtual environment to use Python 3.6 or 3.9
Use the appropriate python command variant if desired:   
```python3.6 -m venv /pythonenv1 --system-site-packages --copies```   
```python3.9 -m venv /pythonenv1 --system-site-packages --copies```   

:star: Creating a venv with site packages will include ibm-db and itoolkit which installs via the python3 based yum packages.   
:star: Any of these base packages should not be installed via pip as they are part of the Python yum RPMs.   
:star: pip should not be upgraded directly via pip as the support level of pip is part of the Python yum RPMs.   


## Create virtual environment without site packages 
You can install your new virtual environment without site packages. You can still install other pip packages in the venv except for ibm-db, itoolkit and possibly the other packages that get installed as part of the Python yum site package installers. SO if you don't need any of the yum-based Python site packages, this method can be used if desired for a lighter weight virtual enviornment.  
```python3 -m venv /pythonenv1```  (Installs using default version of Python3.)     
```python3.6 -m venv /pythonenv1```   
```python3.9 -m venv /pythonenv1```   

# Activate the Python environment   
```source /pythonenv1/bin/activate```

# Command prompt looks like this after virtual environment (venv) activation   
```(pythonenv1) -bash-5.1$``` 

# List installed Python packages globally or when a virtual environment is activated   
This command works in the base Python environment or an active virtual environment.    
```pip3 list```

Example package list:   
```
Package    Version
---------- -------
pip        22.0.4
setuptools 58.1.0
```

# Installing Python packages with pip - potential issues with V7R4 and V7R5     

```Pre V7R4``` you can simply install with pip3 command. gcc is used which is gcc v6.x.   
```
pip3 install pyodbc
pip3 install flask
pip3 install itoolkit
pip3 install ibm-db
```

```For V7R4 and V7R5``` - pip3 processes **MAY require** gcc10 compiler to build so use CC/GCC prefixes below for installing pip3 packages. Or set the CC and CXX environment variable before installing packages with pip3.    
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

# Installing specific default pip packages in your active virtual environment
Create a **requirements.txt** file in your **virtual environment directory** in a subdirectory called **src**. You could also place the requirements.txt in your desired app directory instead. it doesn't really matter as long as your virtual environment has been activated. Just don't put them in the root of the virtual environment directory. (Ex: /pythonenv1)      

Ex: ```/pythonenv1/src/requirements.txt```

Example requirements.txt file wiht one or more pip packages listed:    
```
flask>=3.0.0
  #Install flask and associated requirements
```

Run the following command line to change to the requirements.txt directory and install the pip requirements for flask in your active virtual environment:   

```
cd /pythonenv1/src
pip3 install -r requirements.txt 
```
This command line example will install flask and any specifically needed pre-requisites in the active virtual environment or globally if you happended to deactivate your virtual environment.    

# Run any python app script you want to test or run    
Run any of your scripts or additional pip3 installs needed in the environment once the environment has been activated.    

# Deactivate the active Python venv
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
This example runs a Python script named: **hello.py** from the /python directory using virtual environment **/pythonenv1** and the **QSHPYRUN** command which is part of the QShell on i utilities. https://github.com/richardschoen/qshoni  The virtual enviornment is activated and then deactivated aftr the python script has run.
```
QSHONI/QSHPYRUN SCRIPTDIR('/python')         
                SCRIPTFILE(hello.py)                         
                PYVERSION(3.9)                                    
                VENVPATH('/pythonenv1')                           
                DSPSTDOUT(*YES)                                   
```                                                                  

# Misc - Same sequence as above to run script in a selected virtual environmnet via bash command line     
```
source /pythonenv1/bin/activate
python3 /python/hello.py
deactivate

```




