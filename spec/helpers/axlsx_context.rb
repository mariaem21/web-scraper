RSpec.shared_context 'axlsx' do

    # all xlsx specs describe must be normalized
    # "folder/view_name.xlsx.axlsx"
    # allow to infer the template path
    template_name = "organizations/download.xlsx.axlsx"

    let(:template_path) do
      ['app', 'views', template_name]
    end

    # This helper will be used in tests
    def render_template(locals = {})
      axlsx_binding = Kernel.binding
      locals.each do |key, value|
        axlsx_binding.local_variable_set key, value
      end
      # define a default workbook and a default sheet useful when testing partial in isolation
      wb = Axlsx::Package.new.workbook
      axlsx_binding.local_variable_set(:wb, wb)
      axlsx_binding.local_variable_set(:sheet, wb.add_worksheet)
  
      # mimics an ActionView::Template class, presenting a 'source' method
      # to retrieve the content of the template
      filename = Rails.root.join(*template_path).to_s
      source = Struct.new(:source).new(File.read(filename))
      axlsx_binding.eval(ActionView::Template::Handlers::AxlsxRails.new.call(source), filename)
      axlsx_binding.local_variable_get(:wb)
    end
end