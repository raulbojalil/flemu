mkdir build\web
del build\web\*.* /f/s/q  

:: Build the flutter app
call flutter build web -t lib\main_prod.dart

:: Copy the files to publish
mkdir mkdir build\web\public
move build\web\*.* build\web\public
move build\web\assets build\web\public
move build\web\icons build\web\public

:: Copy the backend files
Xcopy /E /I backend build\web

:: Run NPM install
cd build\web
npm install

