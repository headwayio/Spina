module Spina
  module Admin
    class EmbedsController < AdminController
      def new
        klass = Spina::Embeds.constantize(embed_type) || embeddables.first
        raise_missing_embed_error! if klass.nil?

        @embeddable = klass.new
      end

      def create
        @embeddable = Spina::Embeds.constantize(embed_type).new(embed_params)

        if @embeddable.valid?
          render turbo_stream: turbo_stream.update(:trix_attachment_html, @embeddable.to_trix_attachment)
        else
          render :new, status: :unprocessable_entity
        end
      end

      private

      def embeddables
        @embeddables ||= current_theme.embeddables
      end
      helper_method :embeddables

      def embed_type
        params[:embed_type]
      end

      def embed_params
        params.require(:embeddable).permit!
      end

      def raise_missing_embed_error!
        raise ArgumentError, t('spina.embeds.not_found', embed_type:)
      end
    end
  end
end
