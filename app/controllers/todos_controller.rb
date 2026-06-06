# app/controllers/todos_controller.rb
class TodosController < ApplicationController
  before_action :set_todo, only: %i[ show edit update destroy toggle_priority ]

  # GET /todos or /todos.json
  def index
    if params[:category].present?
      @todos = Todo.with_category(params[:category])
    else
      @todos = Todo.all
    end
  end

  # GET /todos/1 or /todos/1.json
  def show
  end

  # GET /todos/new
  def new
    @todo = Todo.new
  end

  # GET /todos/1/edit
  def edit
  end

  # POST /todos or /todos.json
  def create
    @todo = Todo.new(todo_params)

    respond_to do |format|
      if @todo.save
        format.html { redirect_to @todo, notice: "Todo was successfully created." }
        format.json { render :show, status: :created, location: @todo }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @todo.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /todos/1 or /todos/1.json
  def update
    respond_to do |format|
      if @todo.update(todo_params)
        format.html { redirect_to @todo, notice: "Todo was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @todo }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @todo.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /todos/1 or /todos/1.json
  def destroy
    @todo.destroy!

    respond_to do |format|
      format.html { redirect_to todos_path, notice: "Todo was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  def hello
    respond_to do |format|
      format.html { render :hello }
      format.json { render json: "hello world!" }
    end
  end

  # PATCH /todos/1/toggle_priority
  def toggle_priority
    @todo.update!(high_priority: !@todo.high_priority)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to todos_path }
    end
  end

  private
    def set_todo
      @todo = Todo.find(params.expect(:id))
    end

    def todo_params
      params.expect(todo: [ :description, :category ])
    end
end