ssh -i vault-vm-key.pem azureuser@<VM>

export VAULT_ADDR=<VAULT_ADDR>

vault operator unseal

#Key 1: 
#Key 2: 
#Key 3: 

export VAULT_TOKEN=<TOKEN>
vault login $VAULT_TOKEN

vault status

# configure auditing
sudo mkdir /var/log/vault
sudo chown vault:vault /var/log/vault

vault audit enable file file_path=/var/log/vault/vault_audit.log log_raw=true
vault audit enable file file_path=/var/log/vault/vault_audit.log

#On vault server enable the syslog audit device to a facility
vault audit enable syslog tag="vault" facility="LOCAL7"
vault audit list -detailed

#Run the following query on azure Logs
Syslog
| where Facility == "local7" 