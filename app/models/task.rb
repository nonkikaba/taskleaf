class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 }
  validate :validate_name_not_including_comma

  belongs_to :user

  scope :recent, -> { order(created_at: :desc) }

  # CSVデータにどの属性をどの順番で出力するかを設定
  def self.csv_attributes
    ["name", "description", "created_at", "updated_at"]
  end

  def self.generate_csv
    # CSV.generateでCSVデータの文字列を生成
    CSV.generate(headers: true) do |csv|
      # CSVの１行目としてヘッダを出力。csv_attributeの属性名をそのままヘッダにしている
      csv << csv_attributes
      all.each do |task|
        # allメソッドで全タスクを取得し、１レコードごとにCSVの１行を出力する
        # sendメソッドはレシーバに対して引数で指定したメソッドを実行する
        # ここではtask.nameやtask.descriptionなど
        csv << csv_attributes.map{ |attr| task.send(attr) }
      end
    end
  end

  def self.import(file)
    # foreachでCSVファイルを１行ずつ読み込む
    # headers: trueの規定により、１行目をヘッダとして無視する
    CSV.foreach(file.path, headers: true) do |row|
      # CSV１行ごとにTaskインスタンスを生成
      # クラスメソッド の中なのでselfがTaskであり、task = newはtask = Task.newと同意
      task = new
      # sliceメソッドは[]のエイリアス。引数で指定した文字列を抜き出して返す
      # taskの各属性に情報を入れ込む
      # to_hashとすることで「属性１の値、属性２の値」というデータを{属性１のヘッダー名　=> 属性１の値...}とすることができる
      task.attributes = row.to_hash.slice(*csv_attributes)
      task.save!
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[name created_at]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  private

  def validate_name_not_including_comma
    errors.add(:name, 'にカンマを含めることはできません') if name&.include?(',')
  end
end
