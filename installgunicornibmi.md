# Installing Python gunicorn server on IBM i 


https://docs.gunicorn.org/en/stable/install.html

Prerequisites

Make sure all Python 3 yum packages installed on IBM i 

Make sure you have the mosgt recent libutil2 yum package installed (0.8.0.1 as of 6/7/2020)

Install the following Python modules
```
pip3 install gunicorn
pip3 install greenlet
pip3 install evently
```


***Async Workers***
You may also want to install Eventlet or Gevent if you expect that your application code may need to pause for extended periods of time during request processing. Check out the design docs for more information on when you’ll want to consider one of the alternate worker types.
```
Install greenlet and eventlet
$ pip install greenlet            # Required for both
$ pip install eventlet            # For eventlet workers
$ pip install gunicorn[eventlet]  # Or, using extra
***Optional***
$ pip install gevent              # For gevent workers
$ pip install gunicorn[gevent]    # Or, using extra
```

gevent process was cancelled. Had to remove: /QOpenSys/pkgs/lib/python3.6/site-packages/zope*

Link on why it takes so long to build gevent. Also how to install with verbose mode: 
```pip install -vvv gevent```

Trying to reinstall gevent. Taking a while. Will see if it completes.



Notes that pointed to libutil2 not being current (Thanks to Calvin)
```
Traceback (most recent call last):
  File "/QOpenSys/pkgs/bin/gunicorn", line 7, in <module>
    from gunicorn.app.wsgiapp import run
  File "/QOpenSys/pkgs/lib/python3.6/site-packages/gunicorn/app/wsgiapp.py", line 9, in <module>
    from gunicorn.app.base import Application
  File "/QOpenSys/pkgs/lib/python3.6/site-packages/gunicorn/app/base.py", line 11, in <module>
    from gunicorn import util
  File "/QOpenSys/pkgs/lib/python3.6/site-packages/gunicorn/util.py", line 9, in <module>
    import fcntl
ImportError: rtld: 0712-001 Symbol libutil_flock was referenced
      from module /QOpenSys/pkgs/lib/python3.6/lib-dynload/fcntl.so(), but a runtime definition
            of the symbol was not found.
rtld: 0712-002 fatal error: exiting.
```  
What a good call to gunicorn on command line to verify installed correctly should look like after successful install:
```
Should look like this:
gunicorn
usage: gunicorn [OPTIONS] [APP_MODULE]
gunicorn: error: No application module specified. (edited) 
```

