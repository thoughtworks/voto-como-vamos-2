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
are using a standard [Ubuntu Precise 64 box][2], which will get
downloaded and added to your Vagrant inventory when you run `vagrant up`.

[1]: http://www.vagrantup.com
[2]: http://files.vagrantup.com/precise64.box

The box should then be booted, updated, provisioned and you'll have
a working version of the application under [localhost:8000][3].

[3]: http://localhost:8000

To do any work, we'd rather rely on the Vagrant setup (otherwise,
you'd have to run Redis, PostgreSQL and the full stack on your local
development environment, which can be unpleasant to set up). If you
want to make that easier, have a look at the `vcv-env` script. When
sourced, it provides a few handy shortcuts. To run any command:

```
$ source vcv-env
$ v whoami
vagrant
```

Or to run any rake task:

```
$ vr about
About your application's environment
Ruby version              1.9.3 (x86_64-linux)
RubyGems version          1.8.23
Rack version              1.4
Rails version             3.2.12
JavaScript Runtime        therubyracer (V8)
Active Record version     3.2.12
Action Pack version       3.2.12
Active Resource version   3.2.12
Action Mailer version     3.2.12
Active Support version    3.2.12
Middleware                …
Application root          /vagrant
Environment               development
Database adapter          postgresql
Database schema version   0
```

Wiki
----

Most pages on the application are wikis, and they live in a separate
branch, `wiki`. To edit them, go to [localhost:8000/admin][5] and
change content to your liking. Every edit generates a commit in the
branch, so remember to push your changes with:

`git push origin wiki`

[5]: http://localhost:8000/admin

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

This software is provided by the copyright holders and contributors "as is" and
any express or implied warranties, including, but not limited to, the implied
warranties of merchantability and fitness for a particular purpose are
disclaimed. In no event shall the copyright owner or contributors be liable for
any direct, indirect, incidental, special, exemplary, or consequential damages
(including, but not limited to, procurement of substitute goods or services;
loss of use, data, or profits; or business interruption) however caused and
on any theory of liability, whether in contract, strict liability, or tort
(including negligence or otherwise) arising in any way out of the use of this
software, even if advised of the possibility of such damage.

The views and conclusions contained in the software and documentation are those
of the authors and should not be interpreted as representing official policies,
either expressed or implied, of Voto Como Vamos.

