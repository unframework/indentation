
# Indentation
[![Build Status](https://travis-ci.org/unframework/indentation.svg?branch=master)](https://travis-ci.org/unframework/indentation)

## DSL Implementation Helper

Combine Unix style "fork" with JS prototypal inheritance to easily implement DSLs for templating.

Both Javascript and CoffeeScript are supported.

Typical template (e.g. Mustache or anything else) can be considered as a *constructor* of a view-model instance. Each level of indentation - a sub-template - is then its own constructor of a sub-instance for a view-model. So in order to implement a template-like DSL, we need to allow syntactic sugar that allows both:

* creating independent sub-instances that mostly don't share state with the current instance
* providing similar environment as well as sharing *some* state with the sub-instance constructor

We achieve that with simple prototypal inheritance and syntactic sugar to "fork" (create a clean new object) a sub-instance.

This allows for libraries to work with the following template-like code:

```js
this.element('bar', function () {
    this.element('h1#sampleHeading', function () {
        this.text(tmpl('Hello, world {{ app.itemList.length }}'));
    });
});

this.element('a', { href: '#' }, function () {
    this.text('Add Item');

    this.on('click', function () {
        this.app.addItem();
    }.bind(this));
});
```

... although it looks much better in CoffeeScript:

```coffee
@when @eval('app.itemList.length'), ->
  @element 'h1#sampleHeading', ->
    @text @tmpl('Hello, world {{ app.itemList.length }}')

  @element 'ul', ->
    @each @eval('app.itemList'), 'item', ->
      @element 'li', ->
        @text @tmpl('This is: {{ item.label }} eh')

        testAction = ((label, cb) -> setTimeout (-> cb('Error processing action')), 500)
        @form { action: testAction }, [ 'itemLabel' ], ->
          @when @eval('form.action.incomplete'), ->
            @text 'Loading...'

          @when @eval('form.action.error'), ->
            @text @tmpl('{{ form.action.error }}')

          @field 'itemLabel', ->
            @element 'label', ->
              @text 'Enter new item label'
              @element 'input[type=text]', ->
                @fieldValue (=> @value())

          @element 'button[type=submit]', -> @text 'Save'

@element 'a', { href: '#' }, ->
  @text 'Add Item'
  @on 'click', => @app.addItem()
```
