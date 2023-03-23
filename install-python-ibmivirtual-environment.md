# IBM i Example to Create a Pyhton Virtual Environment in PASE

# Make Python virtual environment directory
This example creates /pythonenv1   
```mkdir /pythonenv1```

# Create a virtual environment

## Create virtual environment with site packages (good idea to do it this way for IBM i. you can still install things in the venv)
```python3 -m venv /pythonenv1 --system-site-packages --copies```

This will include ibm-db which installed via yum packages.

## Create virtual environment without site packages (good idea. you can still install things in the venv)
```python3 -m venv /pythonenv1```

# Activate the Python environment
```source /pythonenv1/bin/activate```

# Command prompt after activation
```(pythonenv1) -bash-5.1$```

# List installed packages in the virtual env
```pip3 list```

Ex:
```
Package    Version
---------- -------
pip        22.0.4
setuptools 58.1.0
```

# Install any packages. 
```
pip3 install pyodbc
pip3 install flask
pip3 install itoolkit
pip3 install ibm-db
```

Note for V7R4 and V7R5 - requires gcc10 compiler to build so use beow prefix or set in environment
```CC='gcc-10 -pthread' CXX='g++-10 -pthread'  pip3 install pyodbc```
```CC='gcc-10 -pthread' CXX='g++-10 -pthread'  pip3 install flask```

Or export as an environment variable and then run pip3 stuff
```export CC='gcc-10 -pthread' CXX='g++-10 -pthread'```

Then install your packages
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

Note: You may want to create above links in ~/bin directory instead of mydir
```

