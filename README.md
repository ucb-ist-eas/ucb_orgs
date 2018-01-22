# UcbOrgs

The ucb_orgs gem is a Rails plugin that provides a model and backing database table for UC Berkeley org units.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ucb_orgs'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ucb_orgs

Once you've installed the gem, you'll need to setup the database table and install the org unit data.

To add the migrations to your app, run:

```
rake ucb_orgs:install
```

Then run `rake db:migrate` as usual.

To load the most recent org unit data, run:

```
rake ucb_orgs:update
```

## Updating

To update your local database with the most recent version of the org chart, run:

```
rake ucb_orgs:update
```

This can safely be run as often as needed.

## Data Model

Org units are hierarchical, and each `OrgUnit` record contains the org unit's code, its level in the hierarchy, and the codes of the org units above it.

For example:

Code | Name | Level | Level_2 | Level_3 | Level_4 | Level_5 | Level_6
----- | ----- | ----- | ----- | ----- | ----- | ----- | -----
AZRAD	| Shared Services Research Admin | 5 |CAMSU	| VCBAS	| AZCSS	| AZRAD

This org unit is at level 5, so the record contains the org units for levels 2, 3, and 4 above.

There is exactly one org unit at level one, UCBKL, which represents the entire campus.

## Usage

The org unit model will be available in your code as `UcbOrgs::OrgUnit.` This is an ordinary ActiveRecord model, so all of the usual methods are available to you.

If you'd like to add or override methods in the model, create `org_unit.rb` in your `models` directory and set it up like this:

```ruby
class OrgUnit < ApplicationRecord
  include UcbOrgs::Concerns::OrgUnit

  # add customized behavior here

end
```

You can name it anything you like, just make sure you have the `include` statement shown above.

