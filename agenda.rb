#!/usr/bin/env ruby
require 'rubygems'
require 'sinatra'
require 'haml'
require 'data_mapper'

# full path!
DataMapper.setup( :default, "sqlite3://#{Dir.pwd}/agenda.db" )

# Define the model
class Contact
  include DataMapper::Resource

  property :id, Serial
  property :firstname, String
  property :lastname, String
  property :email, String
end

DataMapper.auto_upgrade!

# Show list of contacts
%w{/ /contacts/?}.each do |r|
  get r do
    haml :list, :locals => { :cs => Contact.all }
  end
end

# Show form to create new contact
get '/contacts/new' do
  haml :form, :locals => {
    :c => Contact.new,
    :action => '/contacts/create'
  }
end

# Create new contact
post '/contacts/create' do
  c = Contact.new
  c.attributes = params
  c.save

  redirect("/contacts/#{c.id}")
end

# Show form to edit contact
get '/contacts/:id/edit' do|id|
  c = Contact.get(id)
  haml :form, :locals => {
    :c => c,
    :action => "/contacts/#{c.id}/update"
  }
end

# Show form to find a contact by firstname
get '/contacts/findform' do
  haml :findform, :locals => {
    :action => "/contacts/find"
  }
end

post '/contacts/find' do
  puts "params = #{params}"
  s = params.select { |k,v| v != '' }
  #s[:order] = [ :lastname.desc]
  s[:order] = [ :lastname.asc]
  puts "selected #{s}"
  cs = Contact.all(s)
  puts cs
  haml :list, :locals => { :cs => cs }
end
#
# Edit a contact
post '/contacts/:id/update' do|id|
  puts "en /contacts/:id/update: params = #{params} id = #{id}"
  c = Contact.get(id)
  puts c.inspect
  
  puts "Fail while recording #{c}" unless c.update(
      :firstname => params[:firstname], 
      :lastname  => params[:lastname], 
      :email     => params[:email])

  redirect "/contacts/#{id}"
end

# Delete a contact
post '/contacts/:id/destroy' do|id|
  c = Contact.get(id)
  c.destroy

  redirect "/contacts/"
end

# View a contact
# TODO: Put at bottom?
get '/contacts/:id' do|id|
  c = Contact.get(id)
  haml :show, :locals => { :c => c }
end

__END__
@@ layout
%html
  %head
    %title Agenda
  %body
    = yield
    %a(href="/contacts/") Contact List
    %a(href="/contacts/findform") Find Contact

@@form
%h1 Create a new contact
%form(action="#{action}" method="POST")
  %label(for="firstname") First Name
  %input(type="text" name="firstname" value="#{c.firstname}")
  %br

  %label(for="lastname") Last Name
  %input(type="text" name="lastname" value="#{c.lastname}")
  %br

  %label(for="email") Email
  %input(type="text" name="email" value="#{c.email}")
  %br

  %input(type="submit")
  %input(type="reset")
  %br

- unless c.id == 0
  %form(action="/contacts/#{c.id}/destroy" method="POST")
    %input(type="submit" value="Destroy")
  
@@show
%table
  %tr
    %td First Name
    %td= c.firstname
  %tr
    %td Last Name
    %td= c.lastname
  %tr
    %td Email
    %td= c.email
%a(href="/contacts/#{c.id}/edit") Edit Contact

@@list
%h1 Contacts
%a(href="/contacts/new") New Contact
%table
  - cs.each do|c|
    %tr
      %td= c.firstname
      %td= c.lastname
      %td= c.email
      %td
        %a(href="/contacts/#{c.id}") Show
      %td
        %a(href="/contacts/#{c.id}/edit") Edit

@@findform
%h1 Find a contact for firstname
%form(action="#{action}" method="POST")
  %label(for="firstname") First Name
  %input(type="text" name="firstname" value="")
  %br

  %label(for="lastname") Last Name
  %input(type="text" name="lastname" value="")
  %br

  %label(for="email") Email
  %input(type="text" name="email" value="")
  %br

  %input(type="submit")
  %input(type="reset")
  %br

