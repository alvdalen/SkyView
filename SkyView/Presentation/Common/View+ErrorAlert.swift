//
//  View+ErrorAlert.swift
//  SkyView
//
//  Created by Adam on 15.02.2026.
//

import SwiftUI

extension View {
    /// Показывает алерт с ошибкой. Один способ для всех экранов: заголовок "Ошибка", текст сообщения, при необходимости кнопка "Повторить".
    ///
    /// - Parameters:
    ///   - message: Текст ошибки для тела алерта. Если nil, алерт не показывается.
    ///   - onRetry: Опциональное действие при нажатии "Повторить". Если задано, в алерте две кнопки: "Повторить" и "Закрыть"; иначе одна "Закрыть".
    ///   - onDismiss: Вызывается при закрытии алерта (по любой кнопке).
    func errorAlert(
        message: String?,
        onRetry: (() -> Void)?,
        onDismiss: @escaping () -> Void
    ) -> some View {
        
        let isPresented = Binding(
            get: {
                message != nil
            },
            set: { newValue in
                guard !newValue else { return }
                onDismiss()
            }
        )
        
        return alert(
            Localized.errorAlertTitle,
            isPresented: isPresented,
            actions: {
                onRetry.map { retry in
                    Button(Localized.retryButton) {
                        retry()
                        onDismiss()
                    }
                }
                Button(Localized.alertDismiss, role: .cancel, action: onDismiss)
            },
            message: {
                Text(message ?? "")
            }
        )
    }
}
