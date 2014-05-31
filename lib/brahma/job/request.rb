module Brahma
  module Job
    module Request
      module_function

      def echo(message)
        {type: :echo, message: message}
      end

      def email(to, subject, content)
        {type: :email, to: to, subject: subject, content: content, create: Time.now, timeout: 60*60*24}
      end
    end
  end
end