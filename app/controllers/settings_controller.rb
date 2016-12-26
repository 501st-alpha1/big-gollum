class SettingsController < ApplicationController
  def show
    @settings = load_settings
  end

  def edit
    @settings = load_settings
  end

  def update
    ['application_name', 'allow_registrations'].each do |item|
      setting = Setting.find_or_initialize_by(key: item)
      input = resource_params[item]

      if !setting.update_attributes(value: input[:value])
        flash.now[:error] = "Could not save setting " + item
        @settings = load_settings
        render :edit
      end
    end

    redirect_to settings_path, flash: {success: "Settings saved"}
  end

  def resource_params
    params.require(:settings).permit(application_name: [:value],
                                     allow_registrations: [:value])
  end

  def load_settings
    [Setting.find_or_initialize_by(key: 'application_name'),
     Setting.find_or_initialize_by(key: 'allow_registrations')]
  end
end
