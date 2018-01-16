 ## Stellar Federation  

### The simplest and cleanest Docker image for running federation

Build and run:
```
docker-compose build
docker-compose up -d
```

Defaults to testnet.

Creates a folder 'stellar' in your home folder.  Everything is stored there, delete it to reset.

To add accounts look inside entry.sh for the line 'INSERT INTO people ...'
Add your accounts there

Edit docker-compose.yml for mainnet

Pull requests welcome!
