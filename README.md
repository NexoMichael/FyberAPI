# FyberAPI


# Run
- Production
    bundle exec rackup -o 0.0.0.0 -p 4567 -E production -D
- Development
    rerun 'rackup -p 4567'

# Tests
  rake spec

# Thoughts
- "Sinatra" was selected as framework for handling HTTP requests and drawing responses because
I have not ever touched it and wanted to check if it is good and interesting for my future development.
Seems to be - yes, but need futher investigation of this gem and determine best bractices for handling multiple controllers,
some route's handling and naming, better assets pipelines. For me it is really great for some API but for real WEb with views,
helpers, partials and so on it need to be fulfilled with other gems like "assets" one. But still it it very simple to be used.
- Did not do normal testing of Controllers/Views cause it is not needed for that task and here they did not really contain much.
For real project Cucumber/Capybara/Selenium should be used for UI and full "clicking" testing
- API lib classes are covered by tests (using RSpec), also did not use Rspec for a long time, maybe about 3 years. Seems like API has
slightly changed and now it is very simple to do some kind of TDD/BDD using RSpec and it is really very fast.
- Found some issues with documentation (like required fields and some non-described fields, example seems to be little outdated, etc.)
but it did not hurt the development, first all tests and behaviour was developed and after that additional "test" was added with real data
and real request send to server - so everything was checked step by step.
- Did not really like to create objects for some kind of API class like "FyberAPI" that should be created once during application start
but as long as I dont really know the real usage of such API (maybe several different configs are used in one Application) do it in
the manner of "Singlton" API object which should be created one for appication/controller/etc. if needed.

