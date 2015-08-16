# Installing prerequisites under Windows: #

1. Download and install **Virtual Box**. Attention! There are known problems with VirtualBox 5.0.2 on Windows 10 hosts and with Windows 10 guests. Some of the problems are fixed in the most recent test build which can be found at https://www.virtualbox.org/wiki/Testbuilds.
2. Download and install **Vagrant** for Windows https://www.vagrantup.com/downloads.html
3. Download and install **GitHub Desktop** for Windows at https://desktop.github.com/
4. From now on use **Git Shell** (on your Desktop) to run all commands since it supports some Linux commands natively, most importantly SSH. This means you won't have to install and set up Putty.
5. (Optional) Install a good text editor such as **Atom** at https://atom.io/

# Set up an ERPNext dev environment using Vagrant: # 

1. Clone this repo into a local folder with `git clone https://github.com/frappe/erpnext_vagrant.git erpnext_vagrant`
2. Start your virtual machine by running `vagrant up`
3. Connect to your guest system via SSH with `vagrant ssh`
4. Set `"developer_mode": 1` in `frappe-bench/sites/site1.local/site_config.json`, for example by running `vim ~/frappe-bench/sites/site1.local/site_config.json`. When in vim press `i` to insert text. After inserting press `ESC` and write `:wq` to write and quite the file. More on vim here https://www.linux.com/learn/tutorials/228600-vim-101-a-beginners-guide-to-vim.
5. Go to your frappe-bench folder with `cd ~/frappe-bench/` and start bench with `bench start`
6. Open your browser on your host system and work on your ERPNExt by browsing to `http://localhost:8000/` or `http://127.0.0.1:8000`
