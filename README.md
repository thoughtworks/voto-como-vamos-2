Voto Como Vamos 2
=================

This is a repository for the new Voto Como Vamos platform. It's a
database-backed Wiki with a few scrapers to gather interesting data
from the many websites the Porto Alegre government offers.

As the data coming from the scrapers is not necessarily uniform,
we chose PostgreSQL with the hstore extension to help with ad-hoc
querying.

Installation and Development
----------------------------

All development is being done inside a [Vagrant][1] box, so you'll 
need it installed and working on your system before you begin. We 
are using a standard [Ubuntu Precise 64 box][2], which you'll need 
to grab and add to your Vagrant inventory:

[1]: http://www.vagrantup.com
[2]: http://files.vagrantup.com/precise64.box

```
$ vagrant box add precise http://files.vagrantup.com/precise64.box
```

Let Vagrant do the rest from there (you need to be online for this):

```
$ vagrant up
```

The box should then be booted, updated, provisioned and you'll have
a working version of the application under [localhost:8000][3].

[3]: http://localhost:8000

*Note*: provisioning and deployment are still being worked on, so
there will be a few failures. Please help us with pull requests
and bug reports!

Contributing
------------

Most development is being done by the [ThoughtWorks Brasil][4] team,
and they have direct access to this repository (so no pull requests
are necessary in this case), but we are of course open to 
contributions from anyone. We'll periodically scan pull requests and
new or updated issues. Get in touch if you're thinking of making a
big change, though – we might have it in the plans and can probably
help you out.

[4]: http://www.thoughtworks.com

License
-------

Copyright (c) 2013, Voto Como Vamos
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met: 

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer. 
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution. 

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

The views and conclusions contained in the software and documentation are those
of the authors and should not be interpreted as representing official policies, 
either expressed or implied, of the FreeBSD Project.

