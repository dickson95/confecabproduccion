
# https://github.com/mileszs/wicked_pdf/blob/master/README.md
platform = RUBY_PLATFORM 

if platform.include?("darwin") # OS X machine 
  binary_path = Rails.root.join('bin', 'wkhtmltopdf-0.9.9-OS-X-i386').to_s 
elsif platform.include?("64-linux") # 64-bit linux machine 
  binary_path = Rails.root.join('bin', 'wkhtmltox/bin/wkhtmltopdf').to_s 
end 

WickedPdf.config = { :exe_path => binary_path }
