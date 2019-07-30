# StrongVault

## Overview

Strong vault is a distributed cloud storage application built for macOS. The application allows you to store individual files across multiple cloud storage providers. 

## Scope
Before spreading a file to different cloud providers, the application will encrypt it. An argument can be made that encryption is sufficient to protect the file from attackers. Spreading the file across multiple cloud providers adds an extra layer of security. 

- If the attacker breaks into 1 cloud provider; the attacker cannot reconstruct the file because he only has some file shards.
- If the attacker breaks into all cloud providers; the attacker cannot reconstruct the file because he does not know the order to reassemble the shards in (additionally, each shard is encrypted).


Only the application knows how to reassemble the shards. 
Only the user knows the password to decrypt. 

This additional layer of security comes at a certain convenience cost: the data may be lost if the app data is cleared or the user forgets his password.
