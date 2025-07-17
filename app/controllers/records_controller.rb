class RecordsController < ApplicationController
  # GET /records
  def index
    @records = Record.all
  end

  # GET /records/1
  def show
    record
  end

  # GET /records/new
  def new
    @record = Record.new
  end

  # GET /records/1/edit
  def edit
    record
  end

  # POST /records
  def create
    @record = Record.new(record_params)

    if record.save
      redirect_to record, notice: "Record was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /records/1
  def update
    if record.update(record_params)
      redirect_to record, notice: "Record was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /records/1
  def destroy
    record.destroy!
    redirect_to records_path, notice: "Record was successfully destroyed.", status: :see_other
  end

private

  # Use callbacks to share common setup or constraints between actions.
  def record
    @record ||= Record.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def record_params
    params.expect(record: %i[url metadata specification])
  end
end
