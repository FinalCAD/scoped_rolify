### VERSION 0.0.7

* bug fix

* refactoring
  * Api signature has changed on with_scoped_role method

* enhancements

* backwards incompatible changes
  * Api signature has changed on with_scoped_role method. Last argument is no longer boolean, is hash of option now.

* deprecations

* roadmap
  * refactoring on root resource API


### VERSION 0.0.6

* bug fix

* enhancements
  * remove eager loading for dynamic method. Cause performance problem with huge table roles.

* backwards incompatible changes

* deprecations

* roadmap
  * refactoring on root resource

### VERSION 0.0.5

* bug fix

* enhancements
  * add notion of root_resource

* backwards incompatible changes

* deprecations

* roadmap
  * refactoring on root resource

### VERSION 0.0.4

* bug fix
  * monkey patch has_role? of Rolify for fixing behavior with heterogeneous role through in sym or string

* enhancements
  * add_scope_role can be add role on none persisted object
  * add method remove_scope_role for manage none persisted object
  * move check into ScopedRolify::Policy

* backwards incompatible changes

* deprecations

### VERSION 0.0.3

* little changes

### VERSION 0.0.2

* Rename gem from scopable to scoped_rolify
* Rename method from scope_role to add_scope_role

### VERSION 0.0.1

* Resctricted add_role method
* Resctricted with_role method