const { exec } = require('child_process');

console.log('CREATING BOOTSTRAP DUMP')
exec('touch ./.BOOTSTRAPPING', function (error, stdout, stderr) {
  exec('rm -rf nodesh && mongodump --db nodesh --excludeCollection contracts --out ./', function (error, stdout, stderr) {
    if (error) {
      console.log(error.stack);
      console.log('Error code: '+error.code);
      console.log('Signal received: '+error.signal);
    }
    console.log('CREATING TAR.GZ FILE')
    exec('tar -czvf nodesh_bootstrap.gz ./nodesh', function (error, stdout, stderr) {
      if (error) {
        console.log(error.stack);
        console.log('Error code: '+error.code);
        console.log('Signal received: '+error.signal);
      }
      console.log('FILE CREATED CORRECTLY, REMOVING DUMP FOLDER')
      exec('rm -rf nodesh', function (error, stdout, stderr) {
          if (error) {
              console.log(error.stack);
              console.log('Error code: '+error.code);
              console.log('Signal received: '+error.signal);
          }
          exec('rm ./.BOOTSTRAPPING', function (error, stdout, stderr) {
            console.log('BOOTSTRAP COMPLETED')
          })
      })
    })
  })
})