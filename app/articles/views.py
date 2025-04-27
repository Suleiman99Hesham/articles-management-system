from django.shortcuts import render
from rest_framework import viewsets
from rest_framework.pagination import PageNumberPagination
from .models import Article
from .serializers import ArticleSerializer

class ArticlePagination(PageNumberPagination):
    page_size = 12

class ArticleViewSet(viewsets.ModelViewSet):
    serializer_class = ArticleSerializer
    pagination_class = ArticlePagination

    def get_queryset(self):
        queryset = Article.objects.all().order_by('-id')
        search = self.request.query_params.get('search', None)

        if search is not None and search.strip() != '':
            queryset = queryset.extra(
                where=["search_vector @@ plainto_tsquery('english', %s)"],
                params=[search],
            )

        return queryset


def search_page(request):
    return render(request, 'articles/search_results.html')