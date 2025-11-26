from django.http import JsonResponse
from django.views import View
from django.db import connection
from datetime import datetime
import pytz

class HealthCheckView(View):
    def get(self, request, *args, **kwargs):
        # Check database connection
        try:
            with connection.cursor() as cursor:
                cursor.execute("SELECT 1")
            db_status = "ok"
        except Exception as e:
            db_status = f"error: {str(e)}"

        return JsonResponse({
            "status": "ok",
            "database": db_status,
            "timestamp": datetime.now(pytz.utc).isoformat(),
            "service": "ATS Application"
        })
