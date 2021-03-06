ActiveAdmin.register RadioArchive do
  menu false

  index do
    column :title do |q|
      link_to q.title, admin_radio_archive_path(q)
    end
    column :guest
    column :date
    column :format
    column :attached_file do |q|
      link_to 'Download', q.attached_file.attachment.url if q.attached_file
    end
  end

  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs 'Details' do
      f.input :title
      f.input :guest
      f.input :date
      f.input :format, as: :select, collection: ['Signs of Life', 'Mediums & Messages', 'The Gathering']
    end

    f.inputs "Recording", :for => [:attached_file, f.object.attached_file || AttachedFile.new] do |recording_form|
      recording_form.input :attachment, as: :file
    end

    f.has_many :embeded_links do |link_form|
      link_form.input :title
      link_form.input :body
    end

    f.buttons
  end


  show do
    h2 radio_archive.title
    div do
      h3 radio_archive.guest
      h3 radio_archive.date.to_s
      h3 radio_archive.format
      link_to 'Download', radio_archive.attached_file.attachment.url if radio_archive.attached_file
    end

    table_for(radio_archive.embeded_links) do
      column "Embeded Links" do |elink|
        elink.body.html_safe
      end
    end
  end

end
