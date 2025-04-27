from django.core.management.base import BaseCommand
from articles.models import Article
from faker import Faker

class Command(BaseCommand):
    help = 'Seed the database with sample articles'

    def handle(self, *args, **kwargs):
        fake = Faker()
        for _ in range(30):
            Article.objects.create(
                title=fake.sentence(nb_words=6),
                body=fake.paragraph(nb_sentences=10)
            )
        self.stdout.write(self.style.SUCCESS('Successfully seeded 30 articles!'))
