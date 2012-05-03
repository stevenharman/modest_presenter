$LOAD_PATH << "../lib"

require 'modest_presenter'

Person = Struct.new(:first_name, :last_name, :age)
InsanePerson = Class.new(Person)
Nerd = Class.new(Person)

evan = Nerd.new("Evan", "Light", 38)
ed = Nerd.new("Ed", "Kim", 27)

# Seems a bit generous calling this guy a Person
w = InsanePerson.new("George W.", "Bush", 66)

class PersonPresenter < ModestPresenters::ModestPresenter
  def name
    "#{first_name} #{last_name}"
  end

  def title
  end
end

class NerdPresenter < PersonPresenter
  def name
    "#{super} is a nerd."
  end
end

class InsanePersonPresenter < PersonPresenter
  def name
    "#{super} wastes oxygen better used by nerds."
  end

  def title
    "President "
  end
end

def present(model, context, &block)
  Object.const_get("#{model.class}Presenter")
        .new(model, context)
        .present(&block)
end

people = [evan, ed, w]

ERB_TEMPLATE = <<-ERB
  <ul>
    <% people.each do |person| %>
      <% present(person, self) do %>
        <li>
          <%= title %><%= name %>
        </li>
      <% end %>
    <% end %>
  </ul>
  <p>Yes, only insane people are President</p>
ERB

require 'erb'
puts ERB.new(ERB_TEMPLATE).result(binding)

# OUTPUTS:
# <ul>
#   <li>
#     Evan Light is a nerd.
#   </li>
#   <li>
#     Ed Kim is a nerd.
#   </li>
#   <li>
#     President George W. Bush wastes oxygen better used by nerds.
#   </li>
# </ul>
# <p>Yes, only insane people are President</p>
