class SettingsController < ApplicationController
  def show
    @settings = load_settings
  end

  def edit
    @settings = load_settings
  end

  def update
    @setting = Setting.find_or_initialize_by(key: 'application_name')

    if @setting.update_attributes(value: resource_params[:application_name][:value])
      redirect_to settings_path, flash: {success: "Settings saved"}
    else
      flash.now[:error] = "Could not save settings"
      @settings = load_settings
      render :edit
    end
  end

  def resource_params
    params.require(:settings).permit(application_name: [:value])
  end

  def load_settings
    [Setting.find_or_initialize_by(key: 'application_name')]
  end
end