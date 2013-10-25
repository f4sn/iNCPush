module IM
 class Kayac
   HOST = 'im.kayac.com'
   def initialize(to, params={})
     if to.nil?
       raise ArgumentError
     else
       @to = to
     end
     @id  = params[:id]
     @pwd = params[:password]
     @sig = params[:sig]
   end

   def notify(msg,han)
     if !@sig.nil?
       sig = Digest::SHA1.hexdigest(msg + @sig)
       data = 'message=%s&amp;handler=%s;sig=%s' % [u(msg),u(han),sig]
     elsif !@pwd.nil?
       data = 'message=%s&amp;password=%s;handler=%s' % [u(msg), u(@pwd),u(han)]
     else
       data = 'message=%s;handler=%s' % [u(msg),u(han)]
     end
     data << '&amp;id=%s' % [u(@id)] unless @id.nil?
     header = {
       'Host' => HOST,
       'Content-Type' => 'application/x-www-form-urlencoded',
       'Content-length' => data.size.to_s,
     }

     path = '/api/post/%s' % [@to]
     Net::HTTP.version_1_2
     Net::HTTP.start(HOST, 80) do |http|
       http.post(path, data, header)
     end
   end
   
   private
   def u(str)
      str.to_s do
       '%%%02X' % $&.unpack("C").first
     end
   end

 end
end