class ApplicationSerializer < ActiveModel::Serializer
  def files
    object.attachments.map do |a|
      {
        url: a.file.url,
        filename: a.file.file.filename,
        id: a.id,
        attachable: a.attachable.class.to_s.downcase
      }
    end
  end
end
