class WordsController < ApplicationController
  before_action :set_word, only: [:show, :edit, :update, :destroy]

  # GET /words
  # GET /words.json
  def index
    @words = Word.all
  end

  # GET /words/1
  # GET /words/1.json
  def show
  end

  # GET /words/new
  def new
    @word = Word.new
  end

  # GET /words/1/edit
  def edit
  end

  # POST /words
  # POST /words.json
  def create
    body,success = get_word word_params[:title]
    @word = Word.new(title: word_params[:title], content: body)
    respond_to do |format|
      if success && body && @word.save
        format.html { redirect_to @word, notice: 'Word was successfully created.' }
        format.json { render :show, status: :created, location: @word }
      else
        format.html { render :new, :notice => 'Cant get word.'}
        format.json { render json: @word.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /words/1
  # PATCH/PUT /words/1.json
  def update
    respond_to do |format|
      if @word.update(word_params)
        format.html { redirect_to @word, notice: 'Word was successfully updated.' }
        format.json { render :show, status: :ok, location: @word }
      else
        format.html { render :edit }
        format.json { render json: @word.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /words/1
  # DELETE /words/1.json
  def destroy
    @word.destroy
    respond_to do |format|
      format.html { redirect_to words_url, notice: 'Word was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def retrive_word
    @word = Word.all.shuffle.first
    if @word.present?
      word_body = YAML.load  @word.to_json(:only => [:title, :content, :learn_date])
      render :json => { :success => true, :word => word_body }
    else
      render :json => { :success => false }
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_word
      @word = Word.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def word_params
      params.require(:word).permit(:title)
    end

    def get_word url
      success = true
      word_link = CAMBRIDGE_URL + word_params[:title].gsub(' ','-')
      begin
         page = Nokogiri::HTML(RestClient.get(word_link))
      rescue => e
        success = false
        return nil, success
      end
      body = {word: []}
      body_result = page.css('div.di-body')
      body_result.css('div.pos-block').each do |pos_block|
        word = {}
        posgram = pos_block.css('.pos-header').css('.posgram').text
        word[:pharse] = posgram
        pronunciation = pos_block.css('.pos-header').css('.pron').text
        word[:pronunciation] = pronunciation
        word[:content] = []
        pos_block.css('.pos-body').css('.def-block').each do |def_block|
          mean = def_block.css('.def').text
          block = {mean: mean}
          def_block.css('.examp').each do |examp|
             block.merge!({example: examp.text})
          end
          word[:content] << block
        end
        body[:word] << word
      end

      if body[:word].empty?
        success = false
      end
      return body, success
    end
end
