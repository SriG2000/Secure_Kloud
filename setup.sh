rm -rf Secure_Kloud

sudo apt-get update

sudo apt-get install python3-venv

git clone git@github.com:SriG2000/Secure_Kloud.git

cd Secure_Kloud

# Find the process IDs (PIDs) of processes using port 5000
pids=$(sudo fuser -n tcp 5000 2>/dev/null)

# Loop through the PIDs and kill the processes
for pid in $pids; do
    sudo kill $pid
done

chmod +x cmd.sh

./req.sh