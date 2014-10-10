#!/usr/bin/sh
./header.py "Install optional dependencies"

# Install Qt and then update the Matplotlib settings
if [[ $TRAVIS_PYTHON_VERSION == 2.7* ]]; then
    sudo apt-get install -q python-qt4
    SCI_QT_API=PyQt4
    export QT_API=pyqt

else
    sudo apt-get install -q libqt4-dev
    pip install PySide $WHEELHOUSE
    python ~/virtualenv/python${TRAVIS_PYTHON_VERSION}/bin/pyside_postinstall.py -install
    SCI_QT_API=PySide
    export QT_API=PySide
fi

# Matplotlib settings - must be after we install Pyside
MPL_DIR=$HOME/.config/matplotlib
mkdir -p $MPL_DIR
touch $MPL_DIR/matplotlibrc
echo 'backend : Agg' > $MPL_DIR/matplotlibrc
echo 'backend.qt4 : '$SCI_QT_API >> $MPL_DIR/matplotlibrc

# imread does NOT support py3.2
if [[  $TRAVIS_PYTHON_VERSION != 3.2 ]]; then
    sudo apt-get install -q libtiff4-dev libwebp-dev libpng12-dev xcftools
    pip install imread
fi

# TODO: update when SimpleITK become available on py34 or hopefully pip
if [[  $TRAVIS_PYTHON_VERSION != 3.4 ]]; then
    easy_install SimpleITK
fi

sudo apt-get install libfreeimage3
pip install astropy

if [[ $TRAVIS_PYTHON_VERSION == 2.* ]]; then
    pip install pyamg
fi
