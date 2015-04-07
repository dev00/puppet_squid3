# squid-hardening (Puppet module)

##This file is work in progress

## Description

This module provides secure squid V3.? configurations.

## Requirements

* Puppet
* Puppet modules: `saz/ssh` (>= 2.3.6), `puppetlabs/stdlib` (>= 4.2.0)


## Parameters

* `ipv6_enabled = false` - true if IPv6 is needed
* `` - 

## Usage

After adding this module, you can use the class:

    class { 'ssh_hardening': }

This will install ssh-server and ssh-client. You can alternatively choose only one via:

    class { 'ssh_hardening::server': }
    class { 'ssh_hardening::client': }

You should configure core attributes:

    class { 'ssh_hardening::server':
      "listen_to" : ["10.2.3.4"]
    }

**The default value for `listen_to` is `0.0.0.0`. It is highly recommended to change the value.**

### Overwriting default options
Default options will be merged with options passed in by the `client_options` and `server_options` parameters.
If an option is set both as default and via options parameter, the latter will win.

The following example will enable X11Forwarding, which is disabled by default:

```puppet
class { 'ssh_hardening':
  server_options => {
    'X11Forwarding' => 'yes',
  },
}
```

## FAQ / Pitfalls

**Question/Probelm description**

If you have exhausted all typical issues (firewall, network, key missing, wrong key, account disabled etc.), it may be that your account is locked. The quickest way to find out is to look at the password hash for your user:

    sudo grep myuser /etc/shadow



## Contributors + Kudos

* Christoph Hartmann [chris-rock](https://github.com/chris-rock)
* Stefan Ludowicy [basisbit](https://github.com/basisbit)
* certain files are based on the project [thias/puppet-squid3](https://github.com/thias/puppet-squid3)

## License and Author

* Author:: Michael Rose <michael.rose@telekom.de>
* Author:: Deutsche Telekom AG

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
